class AddIsPhantomToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :is_phantom, :boolean, default: false
    add_index :users, :is_phantom
  end
end
