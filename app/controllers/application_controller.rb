class ApplicationController < ActionController::Base    
    def redirect_unless_logged_in
        redirect_to root_url unless signed_in?
    end
end
