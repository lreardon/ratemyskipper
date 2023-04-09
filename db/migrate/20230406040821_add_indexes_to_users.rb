class AddIndexesToUsers < ActiveRecord::Migration[7.0]
  def change
    add_index :users, :firstname
    add_index :users, :lastname
  end
end
