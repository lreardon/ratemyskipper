class AddStatusToFriendships < ActiveRecord::Migration[7.0]
  def change
    add_column :friendships, :status, :string
    add_index :friendships, :status
  end
end
