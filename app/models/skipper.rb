# The Skipper class represents a human skipper, who employees those humans who create User accounts.
class Skipper < ApplicationRecord
  attribute :firstname
  attribute :lastname
  attribute :boatname
  enum fishery: Fisheries.constants.map { |c| Fisheries.const_get c }.index_with(&:to_s)
  attribute :active, default: true

  # Add validations for presence of all of the above properties

  def name
    "#{firstname} #{lastname}"
  end
end
