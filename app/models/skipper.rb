# The Skipper class represents a human skipper, who employees those humans who create User accounts.
class Skipper < ApplicationRecord
  attribute :firstname
  attribute :lastname
  attribute :boatname, :boatname
  attribute :fishery
  attribute :active, default: true
  attribute :creator_id

  belongs_to :creator, class_name: 'User', foreign_key: :creator_id
  has_many :reviews, dependent: :destroy

  # Add validations for presence of all of the above properties
  validates :firstname, :lastname, :boatname, presence: true

  validate :is_unique

  def name
    "#{firstname} #{lastname}"
  end

  private

  def is_unique
    skippers = Skipper.where(firstname: firstname, lastname: lastname, boatname: boatname)

    raise DuplicateRecordError if skippers.count > 1
    
    return if skippers.count == 0
    
    skipper = skippers.first
    errors.add(:skipper_id, 'already exists') unless skipper.id == id
  end
end