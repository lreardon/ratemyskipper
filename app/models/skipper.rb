# The Skipper class represents a human skipper, who employees those humans who create User accounts.
class Skipper < ApplicationRecord
  attribute :firstname
  attribute :lastname
  attribute :boatname
  enum fishery: Fisheries.constants.map { |c| Fisheries.const_get c }.index_with(&:to_s)
  attribute :active, default: true
  attribute :creator_id

  belongs_to :creator, class_name: 'User', foreign_key: :creator_id
  has_many :reviews

  # Add validations for presence of all of the above properties
  validates :firstname, :lastname, :boatname, presence: true

  def name
    "#{firstname} #{lastname}"
  end
end
