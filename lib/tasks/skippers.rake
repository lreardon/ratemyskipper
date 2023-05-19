desc 'Manage our Skipper Records'

namespace :skippers do
	task populate: [:environment] do
		require 'csv'

		all_vessels_table = CSV.parse(File.read("#{Rails.root}/data/Vessels2023.csv"), headers: true, liberal_parsing: true)

		fishing_vessels_table = CSV::Table.new(
			all_vessels_table.filter do |row|
				row['Fishing'] == 'Yes' &&
				row['Vessel Name'] &&
				(row['First name'] || row['Last name'])
			end
		).sort_by { |row| row['First name'] }

		fishing_vessels_table.each do |row|
			p "#{row['First name']} #{row['Last name']} | #{row['Vessel Name']}"

			skipper_params = {
				firstname: row['First name']&.titleize,
				lastname: row['Last name']&.titleize,
				boatname: row['Vessel Name']&.titleize,
				city: row['City']&.titleize,
				state: row['State'],
				creator_id: User.find_by(email: Admin::EMAIL).id,
				populated: true
			}
			skipper = Skipper.new(skipper_params)

			next if skipper.save

			skipper.errors.each do |e|
				p e.full_message
			end
		end
	end

	task dedup: [:environment] do
		Skipper.all.each do |skipper|
			same_name_skippers = Skipper.where(firstname: skipper.firstname, lastname: skipper.lastname)
			same_name_skippers.each do |s|
				next unless s != skipper && s.city == skipper.city && s.state == skipper.state

				deleted = s.delete
				p "Deleted duplicate record #{deleted.name}"
			end
		end
	end
end
