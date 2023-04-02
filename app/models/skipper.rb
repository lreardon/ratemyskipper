"""
The Skipper class represents a human skipper, who employees those humans who create User accounts.
"""

class Skipper < ApplicationRecord
  attribute :firstname
  attribute :lastname
  attribute :boatname
  enum fishery: %i[kodiak bristol_bay]
  attribute :active

  # Add validations for presence of all of the above properties
end