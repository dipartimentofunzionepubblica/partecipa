require 'omniauth'

module OmniAuth
  module Strategies
    class Spidauth
		include OmniAuth::Strategy
		include Spid::Rails::RouteHelper
		  
		def request_phase
			idp_param = request.params["idp_param"]
			attribute_service_index_param = request.params["attribute_service_index_param"] || 0
			redirect spid_login_path(idp_name: idp_param, authn_context: Spid::L1, attribute_service_index: attribute_service_index_param)
		end

		def callback_phase
			begin
				puts "session[:spid]['session_index'] = " + session[:spid]["session_index"].inspect
				puts "session[:spid]['attributes'] = " + session[:spid]["attributes"].inspect
				
				if !session.nil? && !session[:spid]["session_index"].blank? && !session[:spid]['attributes'].blank?
					@provider = session[:spid]['idp']
					@uid = session[:spid]['attributes']['spid_code']
					@email = session[:spid]['attributes']['email']
					@first_name = session[:spid]['attributes']['name']
					@last_name = session[:spid]['attributes']['family_name']
					#session.delete("spid")
					auth_hash 
					super
				elsif !session[:spid]['errors'].blank?
					puts "session[:spid]['errors'] = "  + session[:spid]['errors'].inspect
					@errors = session[:spid]['errors']
				end
			rescue StandardError => e
				puts "Spidauth.callback_phase ==============>" + e.message
				puts "Backtrace:\n\t#{e.backtrace.join("\n\t")}"
			end
		end
	  
		def auth_hash
			begin
				OmniAuth::Utils.deep_merge(super(), {
				  'provider' => @provider,
				  'uid' => @uid,
				  'user_info' => {
					'email'	   => @email,
					'first_name' => @first_name,
					'last_name' => @last_name,
				  },
				  'extra' => {
					'user_hash' => @errors
				  }
				})
			rescue StandardError => e
				puts "Spidauth.auth_hash ==============>" + e.message
				puts "Backtrace:\n\t#{e.backtrace.join("\n\t")}"
			end
		end
		
		def authorize_params
			super.merge(idp_param: request.params["idp_param"], attribute_service_index_param: request.params["attribute_service_index_param"])
		end
    end
  end
end