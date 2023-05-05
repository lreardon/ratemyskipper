class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def facebook
      @user = User.from_omniauth(auth)
      if @user.persisted?
        sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
        # I don't want the flash messages in here, but I don't want to forget about this 'is_navigational_format?' method.
        # set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?
      else
        session["devise.facebook_data"] = request.env["omniauth.auth"].except(:extra) # Removing extra as it can overflow some session stores
        redirect_to new_user_registration_url
      end
    end

    def google_oauth2
      # @user = User.from_google(from_google_params)
      puts 'Yo let\'s check this all out PROFILE'
      puts auth.info.profile
      @user = User.from_omniauth(auth)
 
      if @user.persisted?
        # sign_out_all_scopes
        # flash[:notice] = t 'devise.omniauth_callbacks.success', kind: 'Google'
        sign_in_and_redirect @user, event: :authentication
      else
        flash[:alert] = t 'devise.omniauth_callbacks.failure', kind: 'Google', reason: "#{auth.info.email} is not authorized."
        redirect_to new_user_registration_url
      end
     end
 
    #  def from_google_params
    #    @from_google_params ||= {
    #      uid: auth.uid,
    #      email: auth.info.email
    #    }
    #  end
 
     def auth
       @auth ||= request.env['omniauth.auth']
     end

    def failure
      redirect_to root_path
    end
  end