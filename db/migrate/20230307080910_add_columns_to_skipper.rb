class AddColumnsToSkipper < ActiveRecord::Migration[7.0]
  def change
    add_column :skippers, :firstname, :string
    add_column :skippers, :lastname, :string
    add_column :skippers, :boatname, :string
    add_column :skippers, :fishery, :string
    add_column :skippers, :active, :boolean
  end
end
