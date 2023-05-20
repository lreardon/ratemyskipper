desc 'Import records from a CSV file'

task :import, %i[model] => %i[environment] do |_t, args|
	require 'csv'

	table = CSV.parse(File.read("#{Rails.root}/data/backup/#{args[:model]}.csv"), headers: true, liberal_parsing: true)

	table.each do |row|
		row.each do |k, v|
			case v
			when 'NULL'
				row[k] = nil
			when 'True'
				row[k] = True
			when 'False'
				row[k] = False
			end

			model = args[:model].singularize.camelcase.constantize

			record = model.new(row)

			next if record.save

			record.errors.each do |e|
				p e.full_message
			end
		end
	end
end
