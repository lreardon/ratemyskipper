desc 'Populate databases with lots of records'

namespace :populate do
	task :skippers do
		require 'csv'
		all_vessels_table = CSV.parse(File.read("#{Rails.root}/data/Vessels2023.csv"), headers: true, liberal_parsing: true)
		fishing_vessels_table = CSV::Table.new(all_vessels_table.filter { |row| row['Fishing'] == 'Yes' && row['Vessel Name'] && (row['First name'] || row['Last name']) })

		fishing_vessels_table.each do |row|
			p "#{row['Vessel Name']} | #{row['First name']} #{row['Last name']}"
			firstname = row['First name']
			lastname = row['Last name']
			boatname = row['Vessel Name']
			city = row['City']
			state = row['State']
		end
	end
end