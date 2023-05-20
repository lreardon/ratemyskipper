desc 'Import records from a CSV file'

task :import, %i[model] => %i[environment] do |_t, args|
	require 'csv'

	table = CSV.parse(File.read("#{Rails.root}/data/import/#{args[:model]}.csv"), headers: true, liberal_parsing: true)

	table.each do |row|
		row.each do |k, v|
			case v
			when 'NULL'
				row[k] = nil
			when 'True'
				row[k] = true
			when 'False'
				row[k] = false
			end
		end

		model = args[:model].singularize.camelcase.constantize

		record = model.new(row)

		begin
			next if record.save(validate: false)

			record.errors.each do |e|
				p e.full_message
			end
		rescue => e # rubocop:disable Style/RescueStandardError
			p e.message
		end
	end
end
