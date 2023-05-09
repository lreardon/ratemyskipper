require 'rails_helper'

describe 'User' do
	it 'should require an email' do
		expect { create(:user, email: nil) }.to raise_error ActiveRecord::RecordInvalid
	end
end