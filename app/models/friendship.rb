class Friendship < ApplicationRecord
    attribute :user_id
    attribute :friend_id
    
    belongs_to :user
    belongs_to :friend, class_name: 'User', foreign_key: :friend_id
end
