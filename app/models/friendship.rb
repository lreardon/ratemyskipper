class Friendship < ApplicationRecord
    attribute :user_id
    attribute :friend_id
    enum status: Friendships::Statuses.constants.map { |c| Friendships::Statuses.const_get c}.index_with(&:to_s)
    
    belongs_to :user
    belongs_to :friend, class_name: 'User', foreign_key: :friend_id

    scope :pending, -> { where(status: Friendships::Statuses::PENDING) }
    scope :accepted, -> { where(status: Friendships::Statuses::ACCEPTED) }
    scope :rejected, -> { where(status: Friendships::Statuses::REJECTED) }
end
