# The Skipper class represents a human skipper, who employees those humans who create User accounts.
class Skipper < ApplicationRecord
	attribute :firstname, :firstname
	attribute :lastname, :lastname
	attribute :boatname, :boatname
	attribute :city
	attribute :state
	attribute :active, default: true
	attribute :creator_id

	belongs_to :creator, class_name: 'User', foreign_key: :creator_id
	has_many :reviews, dependent: :destroy

	# Add validations for presence of all of the above properties
	validates :firstname, :lastname, :boatname, presence: true

	validate :unique?

	def name
		"#{firstname} #{lastname}"
	end

	private

	def unique?
		skippers = Skipper.where(firstname:, lastname:, city:, state:)

		raise DuplicateRecordError if skippers.count > 1

		return if skippers.count.zero?

		skipper = skippers.first
		errors.add(:skipper_id, "named #{name} in #{city}, #{state} already exists") unless skipper.id == id
	end
end