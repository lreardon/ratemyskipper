FactoryBot.define do
	factory :skipper do
		# creator_id
		firstname { Faker::Name.first_name }
		lastname { Faker::Name.last_name }
		boatname { Faker::Random.words 2 }
		city { Faker::Address.city }
		state { Faker::Address.state_abbr }
	end
end
