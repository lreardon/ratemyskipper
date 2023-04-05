class Review < ApplicationRecord
  attribute :author_id
  attribute :skipper_id
  attribute :would_return
  attribute :reckless
  attribute :did_not_pay
  attribute :aggressive
  attribute :comment

  belongs_to :author, class_name: 'User', foreign_key: :author_id
  belongs_to :skipper, class_name: 'Skipper'

  def flags?
    aggressive || did_not_pay || reckless
  end

  def flags
    f = []
    f.append(Flags::Bad::RECKLESS) if reckless
    f.append(Flags::Bad::DID_NOT_PAY) if did_not_pay
    f.append(Flags::Bad::AGGRESSIVE) if aggressive
    f
  end
end
