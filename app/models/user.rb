class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  attribute :firstname
  attribute :lastname
  attribute :email

  validates :firstname, :lastname, :email, presence: true
  validates :email, uniqueness: { case_sensitive: false }

  has_many :created_skippers, class_name: 'Skipper', foreign_key: :creator_id, dependent: :nullify
  has_many :authored_reviews, class_name: 'Review', foreign_key: :author_id, dependent: :destroy
  has_many :friendships, dependent: :destroy 

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
    "#{firstname} #{lastname}"
  end

  def friendship_exists_with?(user)
    friendships.map(&:friend).include?(user)
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
