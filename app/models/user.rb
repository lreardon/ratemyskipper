class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  devise :omniauthable, omniauth_providers: %i[facebook]

  attribute :firstname, :firstname
  attribute :lastname, :lastname
  attribute :email, :string
  attribute :is_phantom, :boolean

  validates :firstname, :lastname, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: Devise.email_regexp }

  has_many :created_skippers, class_name: 'Skipper', foreign_key: :creator_id, dependent: :nullify
  has_many :authored_reviews, class_name: 'Review', foreign_key: :author_id, dependent: :destroy
  has_many :friendships, class_name: 'Friendship', foreign_key: :user_id, dependent: :destroy

  scope :confirmed, -> { where.not(confirmed_at: nil) }

  def self.from_omniauth(auth)
    name_split = auth.info.name.split(" ")
    user = User.where(email: auth.info.email).first
    user ||= User.create!(provider: auth.provider, uid: auth.uid, firstname: name_split[0], lastname: name_split[1], email: auth.info.email, password: Devise.friendly_token[0, 20], confirmed_at: DateTime.now)
      user
  end

  def can_delete_skipper?(skipper)
    skipper.creator_id == id
  end

  def can_edit_skipper?(skipper)
    skipper.creator_id == id
  end

  def reviewed_skipper?(skipper)
    authored_reviews.map(&:skipper_id).include?(skipper.id)
  end

  def wrote_review?(review)
    authored_reviews.map(&:id).include?(review.id)
  end

  def name
    "#{firstname} #{lastname}".titleize
  end

  def friendship_exists_with?(user)
    friends_user_added = Friendship.where(user_id: id).map(&:friend)
    friends_friend_added = Friendship.where(friend_id: id).map(&:user)

    users_in_some_kind_of_friendship = friends_user_added.union(friends_friend_added)

    users_in_some_kind_of_friendship.include?(user)
  end

  def friends_with?(user)
    friends.include?(user)
  end

  def pending_friends_with?(user)
    friendships.pending.map(&:friend).include?(user)
  end

  def rejected_friends_with?(user)
    friendships.rejected.map(&:friend).include?(user)
  end

  def pending_friendships
    Friendship.pending.where(friend_id: id)
  end

  def friends
    friends_user_added = Friendship.accepted.where(user_id: id).map(&:friend)
    friends_friend_added = Friendship.accepted.where(friend_id: id).map(&:user)

    friends_user_added.union(friends_friend_added)
  end
end
