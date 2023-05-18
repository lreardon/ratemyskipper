FactoryBot.define do
	factory :skipper do
		# creator_id
		firstname { Faker::Name.first_name }
		lastname { Faker::Name.last_name }
		boatname { "#{Faker::Name.feminine_name} #{Faker::Name.feminine_name}" }
		city { Faker::Address.city }
		state { Faker::Address.state_abbr }
	end
end
