class ApplicationController < ActionController::Base
    before_action :turbo_frame_request_variant
    after_action :discard_flash_notices

    def redirect_unless_logged_in
        redirect_to root_url unless signed_in?
    end

    private

    def turbo_frame_request_variant
        request.variant = :turbo_frame if turbo_frame_request?
    end

    def discard_flash_notices
        flash.discard(:notice)
    end
end
