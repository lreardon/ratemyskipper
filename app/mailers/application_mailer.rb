class ApplicationMailer < ActionMailer::Base
	default from: "Leland Reardon <leland@skipperbuoy.com>"
	layout "mailer"

	def invite_email
		@user = params[:from_user]
		# @message = params[:message]
		puts 'ABOUT TO SEND THE EMAIL'
		mail(to: params[:email], subject: "#{@user.firstname} has invited you to SkipperBuoy!")
		puts 'sent to'
		puts params[:email] 
	end

	def contact_email
		@message = params[:message]
		@email = params[:email]
		mail(to: 'leland@skipperbuoy.com', subject: "SkipperBuoy Contact")
	end
end