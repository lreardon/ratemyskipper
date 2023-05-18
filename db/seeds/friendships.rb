User.all.each do |user|
	other_users = User.all.filter { |u| u.id != user.id }
	other_users_without_frieindship = other_users.filter { |u| !user.friendship_with?(u) }

	number_of_friend_requests_to_send = Faker::Number.number % (other_users_without_frieindship.count + 1)

	users_to_request_friendship_with = other_users_without_frieindship.sample(number_of_friend_requests_to_send)
	users_to_request_friendship_with.each do |user_to_request_friendship_with|
		friendship = user.request_friendship_with!(user_to_request_friendship_with)

		case Faker::Number.number % 3
		when 0
			user_to_request_friendship_with.accept_friend_request!(friendship)
		when 1
			user_to_request_friendship_with.reject_friend_request!(friendship)
		else
			# Leave the request as pending.
		end
	end
end
