# frozen_string_literal: true
require "#{Rails.root}/lib/spid/lib/spid/rack/login.rb"
require "#{Rails.root}/lib/spid/lib/spid/rack/sso.rb"
require "#{Rails.root}/lib/spid/lib/spid/saml2/authn_request.rb"
require "#{Rails.root}/lib/spid/lib/spid/saml2/idp_metadata_parser.rb"
require "#{Rails.root}/lib/spid/lib/spid/saml2/identity_provider.rb"
require "#{Rails.root}/lib/spid/lib/spid/saml2/response_validator.rb"
require "#{Rails.root}/lib/spid/lib/spid/saml2/settings.rb"
require "#{Rails.root}/lib/spid/lib/spid/saml2/sp_metadata.rb"
require "#{Rails.root}/lib/spid/lib/spid/saml2/service_provider.rb"
require "#{Rails.root}/lib/spid/lib/spid/slo/response.rb"
require "#{Rails.root}/lib/spid/lib/spid/sso/request.rb"
require "#{Rails.root}/lib/spid/lib/spid/sso/response.rb"
require "#{Rails.root}/lib/spid/lib/spid/identity_provider_manager.rb"
require "#{Rails.root}/lib/spid/lib/spid/configuration.rb"
require "#{Rails.root}/lib/spid/lib/spid/version.rb"
require "#{Rails.root}/lib/spid/saml2.rb"
require "#{Rails.root}/lib/spid/lib/spid.rb"

Spid.configure do |config|
  config.hostname = Rails.application.secrets.spid_hostname

  config.idp_metadata_dir_path = Rails.root.join('config', 'idp_metadata')
  config.private_key_pem = File.read(Rails.root.join('lib', '.keys', 'private_key.pem'))
  config.certificate_pem = File.read(Rails.root.join('lib', '.keys', 'certificate.pem'))

  config.metadata_path = Rails.application.secrets.spid_metadata_path
  config.login_path = Rails.application.secrets.spid_login_path
  
  config.logout_path = Rails.application.secrets.spid_logout_path
  config.acs_path = Rails.application.secrets.spid_acs_path
  config.slo_path = Rails.application.secrets.spid_slo_path
  config.default_relay_state_path = Rails.application.secrets.spid_default_relay_state_path
  
  config.digest_method = Rails.application.secrets.spid_digest_method.constantize
  config.signature_method = Rails.application.secrets.spid_signature_method.constantize
  config.acs_binding = Rails.application.secrets.spid_acs_binding.constantize
  config.slo_binding = Rails.application.secrets.spid_slo_binding.constantize
  config.attribute_services = [
    { name: 'Decidim', fields: [:spid_code, :email] }
  ]
  
  config.organization_name = Rails.application.secrets.spid_organization_name
  config.organization_display_name = Rails.application.secrets.spid_organization_display_name
  config.organization_url = Rails.application.secrets.spid_organization_url
end
