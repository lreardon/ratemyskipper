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
end
