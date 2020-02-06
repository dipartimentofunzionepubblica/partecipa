module Decidim
  module Devise
    # Custom Devise SessionsController to avoid namespace problems.
    class SessionsController < ::Devise::SessionsController
      include Decidim::DeviseControllers
	  include Spid::Rails::RouteHelper
	  
      before_action :check_sign_in_enabled, only: :create
	  before_action :set_spid_identity_provider, only: :destroy
	  
      def create
        super
      end

      def after_sign_in_path_for(user)
        if first_login_and_not_authorized?(user) && !user.admin? && !pending_redirect?(user)
          decidim_verifications.first_login_authorizations_path
        else
          super
        end
      end

      # Calling the `stored_location_for` method removes the key, so in order
      # to check if there's any pending redirect after login I need to call
      # this method and use the value to set a pending redirect. This is the
      # only way to do this without checking the session directly.
      def pending_redirect?(user)
        store_location_for(user, stored_location_for(user))
      end

      def first_login_and_not_authorized?(user)
        user.is_a?(User) && user.sign_in_count == 1 && current_organization.available_authorizations.any? && user.verifiable?
      end

      def after_sign_out_path_for(user)
		if @identity_provider																																					
			SpidLogger.info("SPID LOGOUT: USERNAME #{@curr_user.name}, NICKNAME #{@curr_user.nickname}, WITH EMAIL #{@curr_user.email} IDP #{@identity_provider} LOGGED OUT")	   
			@curr_user = nil
			spid_logout_url(idp_name: @identity_provider) 
		else
			request.referer || super
		end
      end

      private

      def check_sign_in_enabled
        redirect_to new_user_session_path unless current_organization.sign_in_enabled?
      end
	  
	  def set_spid_identity_provider
		@identity_provider = session[:spid]['idp'] if !session[:spid].blank?
		@curr_user = current_user
	  end
	  
    end
  end
end