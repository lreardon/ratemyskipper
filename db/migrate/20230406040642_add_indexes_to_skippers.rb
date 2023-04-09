class AddIndexesToSkippers < ActiveRecord::Migration[7.0]
  def change
    add_index :skippers, :firstname
    add_index :skippers, :lastname
    add_index :skippers, :boatname
    add_index :skippers, :fishery
    add_index :skippers, :active
    add_index :skippers, :creator_id
  end
end
