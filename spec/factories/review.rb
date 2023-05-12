FactoryBot.define do
	factory :review do
		# author_id
		# skipper_id
		would_return { Faker::Boolean.boolean }
		reckless { Faker::Boolean.boolean }
		did_not_pay { Faker::Boolean.boolean }
		aggressive { Faker::Boolean.boolean }
		comment { Faker::Lorem.paragraph }
		paid_retros { Faker::Boolean.boolean }
		paid_fuel { Faker::Boolean.boolean }
		paid_food { Faker::Boolean.boolean }
		good_teacher { Faker::Boolean.boolean }
		anonymity { Reviews::Anonymities.constants.map(&Reviews::Anonymities.method(:const_get)).sample }
		fished_for_skipper { true }
		review_is_truthful { true }
	end
end