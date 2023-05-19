class AddPopulatedToSkippers < ActiveRecord::Migration[7.0]
	def change
		add_column :skippers, :populated, :boolean, default: false
		add_index :skippers, :populated
	end
end
