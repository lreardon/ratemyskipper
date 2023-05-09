FactoryBot.define do
	factory :review do
		# author_id
		# skipper_id
		would_return { Faker::Datatype.boolean }
		reckless { Faker::Datatype.boolean }
		did_not_pay { Faker::Datatype.boolean }
		aggressive { Faker::Datatype.boolean }
		comment { Faker::Lorem.paragraph }
		paid_retros { Faker::Datatype.boolean }
		paid_fuel { Faker::Datatype.boolean }
		paid_food { Faker::Datatype.boolean }
		good_teacher { Faker::Datatype.boolean }
		# anonymity { Reviews::Anonymities.constants.map(&Reviews::Anonymities.mehtod(:const_get)).sample }
		# fished_for_skipper
		# review_is_truthful
	end
end