FactoryBot.define do
	factory :skipper do
		# creator_id
		firstname { Faker::Name.first_name }
		lastname { Faker::Name.last_name }
		boatname { Faker::Random.words 2 }
		fishery { Fisheries.constants.map(&Fisheries.method(:const_get)).sample }
	end
end
