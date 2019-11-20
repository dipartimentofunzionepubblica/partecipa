# frozen_string_literal: true

require "base64"

module Spid
  module Saml2
	class Settings # :nodoc:
	  attr_reader :identity_provider
	  attr_reader :service_provider
	  attr_reader :authn_context
	  attr_reader :attribute_index

	  def initialize(
			identity_provider:,
			service_provider:,
			attribute_index: nil,
			authn_context: nil
		  )
		@authn_context = authn_context || Spid::L1
		@attribute_index = attribute_index
		unless AUTHN_CONTEXTS.include?(@authn_context)
		  raise Spid::UnknownAuthnContextError,
				"Provided authn_context '#{@authn_context}' is not valid:" \
				" use one of #{AUTHN_CONTEXTS.join(', ')}"
		end
		@identity_provider = identity_provider
		@service_provider = service_provider
	  end

	  def idp_entity_id
		identity_provider.entity_id
	  end

	  def idp_sso_target_url
		identity_provider.sso_target_url
	  end

	  def idp_slo_target_url
		identity_provider.slo_target_url
	  end

	  def sp_entity_id
		service_provider.host
	  end

	  def sp_acs_url
		service_provider.acs_url
	  end

	  def sp_acs_binding
		service_provider.acs_binding
	  end

	  def sp_slo_service_url
		service_provider.slo_url
	  end

	  def sp_slo_service_binding
		service_provider.slo_binding
	  end

	  def sp_attribute_services
		service_provider.attribute_services
	  end

	  def private_key
		service_provider.private_key
	  end

	  def certificate
		service_provider.certificate
	  end

	  def idp_certificate
		identity_provider.certificate
	  end

	  def signature_method
		service_provider.signature_method
	  end

	  def digest_method
		service_provider.digest_method
	  end

	  def acs_index
		"0"
	  end
	  
	  def organization_name
		service_provider.organization_name
	  end
	  
	  def organization_display_name
		service_provider.organization_display_name
	  end
	  
	  def organization_url
		service_provider.organization_url
	  end
	  
	  def force_authn?
		authn_context > Spid::L1
	  end

	  def x509_certificate_der
		@x509_certificate_der ||=
		  begin
			Base64.encode64(certificate.to_der).delete("\n")
		  end
	  end
	end
  end
end