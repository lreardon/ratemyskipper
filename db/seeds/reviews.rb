User.all.each do |user|
	user.created_skippers.each do |skipper|
		Review.create!(
			author_id: user.id,
			skipper_id: skipper.id,
			comment: Faker::Lorem.paragraph,
			would_return: Faker::Boolean.boolean,
			reckless: Faker::Boolean.boolean,
			did_not_pay: Faker::Boolean.boolean,
			aggressive: Faker::Boolean.boolean,
			paid_retros: Faker::Boolean.boolean,
			paid_fuel: Faker::Boolean.boolean,
			paid_food: Faker::Boolean.boolean,
			good_teacher: Faker::Boolean.boolean,
			anonymity: Reviews::Anonymities.constants.map(&Reviews::Anonymities.method(:const_get)).sample,
			fished_for_skipper: true,
			review_is_truthful: true
		)
		p "#{user.name} reviewed #{skipper.name}"
	end

	additional_skipper = Skipper.all.filter { |s| !user.created_skippers.map(&:id).include?(s.id) }.sample
	Review.create!(
		author_id: user.id,
		skipper_id: additional_skipper.id,
		comment: Faker::Lorem.paragraph,
		would_return: Faker::Boolean.boolean,
		reckless: Faker::Boolean.boolean,
		did_not_pay: Faker::Boolean.boolean,
		aggressive: Faker::Boolean.boolean,
		paid_retros: Faker::Boolean.boolean,
		paid_fuel: Faker::Boolean.boolean,
		paid_food: Faker::Boolean.boolean,
		good_teacher: Faker::Boolean.boolean,
		anonymity: Reviews::Anonymities.constants.map(&Reviews::Anonymities.method(:const_get)).sample,
		fished_for_skipper: true,
		review_is_truthful: true
	)

	p "#{user.name} reviewed #{additional_skipper.name}"
end
