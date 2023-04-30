class PagesController < ApplicationController

  def index
    redirect_if_signed_in
  end

  def about; end

  def contact; end

  def privacy_policy; end

  def terms_of_service; end

  private

  def redirect_if_signed_in
    redirect_to skippers_path if signed_in?
  end
end
