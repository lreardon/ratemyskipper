# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
	# GET /resource/password/new
	# def new
	#   super
	# end

	# POST /resource/password
	def create
		if (user = User.find_by(email: params[:user][:email])) && !user.provider.nil?
			p 'HEY HEY'
			redirect_to :back, alert: "The user associated with this email address logs in with #{helpers.display_omniauth_provider(user.provider)}."
		end

		p 'HEY WHAT THE FUCK'
		super
	end

	# GET /resource/password/edit?reset_password_token=abcdef
	# def edit
	#   super
	# end

	# PUT /resource/password
	# def update
	#   super
	# end

	# protected

	# def after_resetting_user_password_path_for(resource) # If implementation of this ever throws an error, add 'user' before 'password' in the method definition, and try again
	#   super(resource)
	# end

	# # The path used after sending reset password instructions
	# def after_sending_reset_user_password_instructions_path_for(resource_name) # If implementation of this ever throws an error, add 'user' before 'password' in the method definition, and try again
	#   super(resource_name)
	# end
end
