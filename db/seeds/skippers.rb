User.all.each do |user|
	skipper = user.create_skipper!(
		firstname: Faker::Name.first_name,
		lastname: Faker::Name.last_name,
		boatname: "#{Faker::Name.feminine_name} #{Faker::Name.feminine_name}",
		city: Faker::Address.city,
		state: Faker::Address.state_abbr
	)
	p "#{user.name} created skipper #{skipper.name}"
end