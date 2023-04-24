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
end
