class CreateFriendships < ActiveRecord::Migration[7.0]
  def change
    create_table :friendships, id: :uuid do |t|
      t.uuid :user_id, index: true
      t.uuid :friend_id, index: true

      t.timestamps
    end
  end
end
