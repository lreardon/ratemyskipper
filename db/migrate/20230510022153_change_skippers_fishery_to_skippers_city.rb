class ChangeSkippersFisheryToSkippersCity < ActiveRecord::Migration[7.0]
	def change
		rename_column :skippers, :fishery, :city
		add_column :skippers, :state, :string
		add_index :skippers, :state
	end
end
