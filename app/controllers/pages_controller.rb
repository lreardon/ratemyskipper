class PagesController < ApplicationController

  def index
    flash[:notice] = 'SkipperBuoy is actively being developed! There may be changes, and you may encounter bugs, but your continued engagement helps to grow the platform.'

    redirect_if_signed_in
  end

  def about; end

  def contact; end

  def send_contact
    params = invite_params

    ApplicationMailer.with(email: params[:email], message: params[:message], from_user: current_user).contact_email.deliver_now
    flash[:notice] = 'Your email was sent successfully!'

    redirect_to contact_path
  end

  def invite; end

  def send_invite
    raise AccessDeniedError unless current_user
    params = invite_params

    @user = current_user
    # @message = params[:message]

    ApplicationMailer.with(email: params[:email], message: params[:message], from_user: current_user).invite_email.deliver_now

    redirect_to users_path
  end

  def privacy_policy; end

  def terms_of_service; end

  private

  def redirect_if_signed_in
    redirect_to skippers_path if signed_in?
  end

  def invite_params
    params.permit(:email, :message)
  end
end
