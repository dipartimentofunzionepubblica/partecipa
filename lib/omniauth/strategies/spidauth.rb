require 'omniauth'

module OmniAuth
  module Strategies
    class Spidauth
		include OmniAuth::Strategy
		include Spid::Rails::RouteHelper
		  
		# receive parameters from the strategy declaration and save them
		#def initialize(app, secret, auth_redirect, options = {})
			#@secret = secret
			#@auth_redirect = auth_redirect
			#super(app, :spid_auth, options)
		#end
		  
		def request_phase
			puts ">>>>>>>>>>>>>>>>>>REQUEST_PHASE!!!!<<<<<<<<<<<<<<<<<<<<<"
			idp_param = request.params["idp_param"]
			redirect spid_login_path(idp_name: idp_param, authn_context: Spid::L1, attribute_service_index: 0)
		end

		#uid { @spid_session_attributes[:spid_code] }

		#def extra
		#  @spid_session_attributes # Return a hash with user data
		#end

		def callback_phase
			# Configure Service SDK
			#@user_details = Session #Service.user_data # Make SDK call to get user details
			puts ">>>>>>>>>>>>>>>>>>CALLBACK_PHASE!!!!<<<<<<<<<<<<<<<<<<<<<"
			begin
				#if !session[:spid].blank?
					#puts "session[:spid] = " + session[:spid].inspect
					if !session[:spid]["session_index"].blank? && !session[:spid]['attributes'].blank?
						#puts "session[:spid]['attributes'] = " + session[:spid]['attributes'].inspect
						#@spid_session_attributes = session[:spid]['attributes']	
						#'spid_code','email','name','family_name'
						@provider = session[:spid]['idp']
						@uid = session[:spid]['attributes']['spid_code']
						@email = session[:spid]['attributes']['email']
						@first_name = session[:spid]['attributes']['name']
						@last_name = session[:spid]['attributes']['family_name']
						#session[:spid] = nil
						auth_hash 
						super
					else
						#puts "session[:spid]['attributes'] = nil" 
						
					end
				#end
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
				  }
				})
			rescue StandardError => e
				puts "Spidauth.auth_hash ==============>" + e.message
				puts "Backtrace:\n\t#{e.backtrace.join("\n\t")}"
			end
		end
		
		def authorize_params
			super.merge(idp_param: request.params["idp_param"])
		end
    end
  end
end