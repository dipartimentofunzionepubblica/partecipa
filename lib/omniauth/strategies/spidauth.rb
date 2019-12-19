require 'omniauth'

module OmniAuth
  module Strategies
    class Spidauth
		include OmniAuth::Strategy
		include Spid::Rails::RouteHelper
		  
		def request_phase
			idp_param = request.params["idp_param"]
			attribute_service_index_param = request.params["attribute_service_index_param"] || 0
			authn_context_param = request.params["authn_context_param_param"] || Spid::L1
			redirect spid_login_path(idp_name: idp_param, authn_context: authn_context_param, attribute_service_index: attribute_service_index_param)
		end

		def callback_phase
			
			logger = Rails.logger
			logger.info 'session[:spid]["session_index"] = ' + session[:spid]["session_index"].inspect
			logger.info 'session[:spid]["attributes"] = ' + session[:spid]["attributes"].inspect
			logger.info 'session[:spid]["errors"] = ' + session[:spid]["errors"].inspect
			
			if !session.nil? && !session[:spid]["session_index"].blank? && !session[:spid]["attributes"].blank?
				@provider = session[:spid]['idp']
				@uid = session[:spid]['attributes']['spid_code']
				@email = session[:spid]['attributes']['email']
				auth_hash 
				super
			elsif !session[:spid]['errors'].blank?
				@errors = session[:spid]['errors']
				auth_hash 
				super
			end
		end
	  
		def auth_hash
			OmniAuth::Utils.deep_merge(super(), {
			  'provider' => @provider,
			  'uid' => @uid,
			  'user_info' => {
				'email'	   => @email
			  },
			  'extra' => {
				'raw_info' => @errors 
			  }
			})
		end
		
		def authorize_params
			super.merge(idp_param: request.params["idp_param"], attribute_service_index_param: request.params["attribute_service_index_param"], authn_context_param: request.params["authn_context_param"])
		end
    end
  end
end