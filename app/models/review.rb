class Review < ApplicationRecord
	attribute :author_id, :uuid
	attribute :skipper_id, :uuid
	attribute :comment, :string
	attribute :would_return, :boolean
	attribute :reckless, :boolean
	attribute :did_not_pay, :boolean
	attribute :aggressive, :boolean
	attribute :paid_retros, :boolean
	attribute :paid_fuel, :boolean
	attribute :paid_food, :boolean
	attribute :good_teacher, :boolean

	enum anonymity: Reviews::Anonymities.constants.map { |c| Reviews::Anonymities.const_get c }.index_with(&:to_s), _default: Reviews::Anonymities::ANONYMOUS

	# Virtual Attributes, for validating POST/PUT
	attribute :fished_for_skipper, :boolean
	attribute :review_is_truthful, :boolean

	belongs_to :author, class_name: 'User', foreign_key: :author_id
	belongs_to :skipper, class_name: 'Skipper'

	validates :fished_for_skipper, inclusion: { in: [true, false], message: 'must be selected' }, acceptance: { message: 'must be certified' }
	validates :review_is_truthful, inclusion: { in: [true, false], message: 'must be selected' }, acceptance: { message: 'must be certified' }

	def flags?
		bad_flags? || good_flags?
	end

	def bad_flags?
		aggressive || did_not_pay || reckless
	end

	def good_flags?
		good_teacher || paid_retros || paid_fuel || paid_food
	end

	def bad_flags
		f = []
		f.append(Flags::Bad::RECKLESS) if reckless
		f.append(Flags::Bad::DID_NOT_PAY) if did_not_pay
		f.append(Flags::Bad::AGGRESSIVE) if aggressive
		f
	end

	def good_flags
		f = []
		f.append(Flags::Good::GOOD_TEACHER) if good_teacher
		f.append(Flags::Good::PAID_RETROS) if paid_retros
		f.append(Flags::Good::PAID_FUEL) if paid_fuel
		f.append(Flags::Good::PAID_FOOD) if paid_food
		f
	end

	def author_visible_for_user?(user)
		return false if anonymous?

		return author.friends_with?(user) if signed_for_friends?

		return true if signed_for_all?

		raise UnpermittedEnumValueError
	end
end
