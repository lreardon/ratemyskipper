User.create!(
	firstname: 'Leland',
	lastname: 'Reardon',
	email: 'leland6925@gmail.com',
	password: 'password',
	confirmed_at: DateTime.now,
	admin: true
)
p 'Created admin user Leland Reardon'

(1..10).each do |_i|
	user = User.create!(
		firstname: Faker::Name.first_name,
		lastname: Faker::Name.last_name,
		email: Faker::Internet.email,
		password: Faker::Internet.password,
		confirmed_at: DateTime.now
	)
	p "Created user #{user.name}"
end
