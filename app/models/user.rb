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
  has_many :friends, through: :friendships

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

  def friends_with?(user)
    friends.include?(user)
  end

  def make_friends_with(user)
    raise AlreadyExistsError if friends_with?(user) or user.friends_with?(self)

    Friendship.create!(user_id: id, friend_id: user.id)
    Friendship.create!(user_id: user.id, friend_id: id)
  end
end
