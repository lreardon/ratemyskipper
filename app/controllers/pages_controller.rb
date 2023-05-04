class PagesController < ApplicationController

  def index
    flash[:notice] = 'SkipperBuoy is actively being developed! There may be changes, and you may encounter bugs, but your continued engagement helps to grow the platform.'

    redirect_if_signed_in
  end

  def about; end

  def contact; end

  def invite; end

  def send_invite
    raise AccessDeniedError unless current_user
    params = send_invite_params

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

  def send_invite_params
    params.permit(:email, :message)
  end
end
