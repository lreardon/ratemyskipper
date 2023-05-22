require 'rails_helper'

describe 'User' do
	it 'should require an email' do
		expect { create(:user, email: nil) }.to raise_error ActiveRecord::RecordInvalid
	end

	it 'should require a unique email' do
		email = 'unique@email.com'
		create(:user, email:)
		expect { create(:user, email:) }.to raise_error ActiveRecord::RecordInvalid
	end

	it 'can delete a skipper it created, even if they are not an admin' do
		user = create(:user, admin: false)
		skipper = create(:skipper, creator_id: user.id)

		user.delete_skipper!(skipper)

		# TODO: include the correct expectation that the skipper no longer exists.
		# expect { Skipper.find_by(id: skipper.id) }.to be nil?
	end

	it 'cannot delete a skipper they did not create if they are not an admin' do
		user = create(:user, admin: false)
		another_user = create(:user)

		skipper = create(:skipper, creator_id: another_user.id)

		expect { user.delete_skipper!(skipper) }.to raise_error UnauthorizedActionError
	end

	it 'can delete a skipper they did not create if they are an admin' do
		user = create(:user, admin: true)
		another_user = create(:user)

		skipper = create(:skipper, creator_id: another_user.id)

		user.delete_skipper!(skipper)

		# TODO: include the correct expectation that the skipper no longer exists.
		# expect { Skipper.find_by(id: skipper.id) }.to be nil?
	end

	it 'can delete a skipper it created if is an admin' do
		user = create(:user, admin: true)
		skipper = create(:skipper, creator_id: user.id)

		user.delete_skipper!(skipper)
	end

	it 'cannot send a friend request if already friends' do
		user = create(:user)
		friend = create(:user)
		create(:friendship, user_id: user.id, friend_id: friend.id, status: Friendships::Statuses::ACCEPTED)

		expect { user.request_friendship_with!(friend) }.to raise_error AlreadyExistsError
		expect { friend.request_friendship_with!(user) }.to raise_error AlreadyExistsError
	end

	it 'cannot send a friend request if a pending friend request between them exists' do
		user = create(:user)
		friend = create(:user)
		create(:friendship, user_id: user.id, friend_id: friend.id, status: Friendships::Statuses::PENDING)

		expect { user.request_friendship_with!(friend) }.to raise_error AlreadyExistsError
		expect { friend.request_friendship_with!(user) }.to raise_error AlreadyExistsError
	end

	it 'cannot send a friend request to someone who\'s previously rejected a friend request from them' do
		user = create(:user)
		friend = create(:user)
		create(:friendship, user_id: user.id, friend_id: friend.id, status: Friendships::Statuses::REJECTED)

		expect { user.request_friendship_with!(friend) }.to raise_error AlreadyExistsError
	end

	it 'can send a friend request to a user who\'s request they\'ve previously rejected' do
		user = create(:user)
		friend = create(:user)
		create(:friendship, user_id: user.id, friend_id: friend.id, status: Friendships::Statuses::REJECTED)

		friend.request_friendship_with!(user)
	end

	it 'has a name consisting of its first and last name, separated by a space' do
		user = create(:user, firstname: 'First', lastname: 'Last')
		expect(user.name).to eq 'First Last' # .to equal ___ compares identity!
	end

	it 'knows who its friends are' do
		user = create(:user)
		# Relationships initiated by the user
		friend = create(:user)
		idol = create(:user)
		enemy = create(:user)
		create(:friendship, user_id: user.id, friend_id: friend.id, status: Friendships::Statuses::ACCEPTED)
		create(:friendship, user_id: user.id, friend_id: idol.id, status: Friendships::Statuses::PENDING)
		create(:friendship, user_id: user.id, friend_id: enemy.id, status: Friendships::Statuses::REJECTED)
		# Relationships initiated by the other user
		reverse_friend = create(:user)
		hopeful = create(:user)
		reverse_enemy = create(:user)
		create(:friendship, user_id: reverse_friend.id, friend_id: user.id, status: Friendships::Statuses::ACCEPTED)
		create(:friendship, user_id: hopeful.id, friend_id: user.id, status: Friendships::Statuses::PENDING)
		create(:friendship, user_id: reverse_enemy.id, friend_id: user.id, status: Friendships::Statuses::REJECTED)
		stranger = create(:user)

		expect(user.friends_with?(friend)).to eq true
		expect(user.friends_with?(reverse_friend)).to eq true
		expect(user.friends_with?(enemy)).to eq false
		expect(user.friends_with?(reverse_enemy)).to eq false
		expect(user.friends_with?(idol)).to eq false
		expect(user.friends_with?(hopeful)).to eq false
		expect(user.friends_with?(stranger)).to eq false
	end

	# The following test deals with our redis store, so we'll have to appropriately handle it, considering this is a test environment.
	# it 'knows who its saved skippers are' do
	# 	user = create(:user)
	# 	skipper = create(:skipper)
	#
	# 	# We should stub out interaction with the cache here.
	#
	# 	expect(user.saved_skipper?(skipper)).eq true
	# end

	it 'should have a saved_skippers_key formatted like "user-<USER_ID>-saved_skippers"' do
		user = create(:user)
		expect(user.saved_skippers_key).to eq "user-#{user.id}-saved-skippers"
	end

	it 'should be considered verified if and only if they have at least two friends' do
		user = create(:user)
		first_friend = create(:user)
		create(:friendship, user_id: user.id, friend_id: first_friend.id, status: Friendships::Statuses::ACCEPTED)

		expect(user.verified?).to eq false

		second_friend = create(:user)
		create(:friendship, user_id: second_friend.id, friend_id: user.id, status: Friendships::Statuses::ACCEPTED)

		expect(user.verified?).to eq true
	end

	it 'knows who it\'s reviewed' do
		user = create(:user)
		reviewed_skipper = create(:skipper, creator_id: user.id)
		stranger_skipper = create(:skipper, creator_id: user.id)
		create(:review, author_id: user.id, skipper_id: reviewed_skipper.id)

		expect(user.reviewed_skipper?(reviewed_skipper)).to eq true
		expect(user.reviewed_skipper?(stranger_skipper)).to eq false
	end

	it 'knows which reviewes it\'s written' do
		user = create(:user)
		other_user = create(:user)
		skipper = create(:skipper, creator_id: user.id)
		user_review = create(:review, author_id: user.id, skipper_id: skipper.id)
		other_user_review = create(:review, author_id: other_user.id, skipper_id: skipper.id)

		expect(user.wrote_review?(user_review)).to eq true
		expect(user.wrote_review?(other_user_review)).to eq false
	end
end
