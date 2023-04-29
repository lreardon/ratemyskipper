class PagesController < ApplicationController

  def index
    redirect_if_signed_in
  end

  def about; end

  def contact; end

  private

  def redirect_if_signed_in
    redirect_to skippers_path if signed_in?
  end
end
