class PagesController < ApplicationController
  before_action :check_signed_in

  def index; end

  private

  def check_signed_in
    redirect_to skippers_path if signed_in?
  end
end
