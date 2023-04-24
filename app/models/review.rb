class Review < ApplicationRecord
  attribute :author_id
  attribute :skipper_id
  attribute :would_return
  attribute :reckless
  attribute :did_not_pay
  attribute :aggressive
  attribute :comment
  enum anonymity: Reviews::Anonymities.constants.map { |c| Reviews::Anonymities.const_get c }.index_with(&:to_s), _default: Reviews::Anonymities::ANONYMOUS

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

  def author_visible_for_user(user)
    return false if anonymous?

    # Reimplement when friendship is done
    # return author.friends_with?(user) if signed_for_friends?

    return true if signed_for_all?

    raise UnpermittedEnumValueError
  end
end
