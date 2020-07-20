# frozen_string_literal: true
require "#{Rails.root}/lib/spid/lib/spid/rack/login.rb"
require "#{Rails.root}/lib/spid/lib/spid/rack/sso.rb"
require "#{Rails.root}/lib/spid/lib/spid/saml2/authn_request.rb"
require "#{Rails.root}/lib/spid/lib/spid/saml2/identity_provider.rb"
require "#{Rails.root}/lib/spid/lib/spid/saml2/idp_metadata_parser.rb"
require "#{Rails.root}/lib/spid/lib/spid/saml2/response.rb"
require "#{Rails.root}/lib/spid/lib/spid/saml2/response_validator.rb"
require "#{Rails.root}/lib/spid/lib/spid/saml2/saml_parser.rb"
require "#{Rails.root}/lib/spid/lib/spid/saml2/service_provider.rb"
require "#{Rails.root}/lib/spid/lib/spid/saml2/settings.rb"
require "#{Rails.root}/lib/spid/lib/spid/saml2/sp_metadata.rb"
require "#{Rails.root}/lib/spid/lib/spid/slo/response.rb"
require "#{Rails.root}/lib/spid/lib/spid/sso/request.rb"
require "#{Rails.root}/lib/spid/lib/spid/sso/response.rb"
require "#{Rails.root}/lib/spid/lib/spid/identity_provider_manager.rb"
require "#{Rails.root}/lib/spid/lib/spid/configuration.rb"
require "#{Rails.root}/lib/spid/lib/spid/version.rb"
require "#{Rails.root}/lib/spid/lib/spid.rb"
require "#{Rails.root}/lib/spid/saml2.rb"
require "#{Rails.root}/lib/spid_access_logger/spid_access_logger.rb"

Spid.configure do |config|
  ACS = YAML::load(File.open("#{Rails.root}/config/spid_acs_list.yml"))["acs_list"].each(&:deep_symbolize_keys!)
  SLO = YAML::load(File.open("#{Rails.root}/config/spid_slo_list.yml"))["slo_list"].each(&:deep_symbolize_keys!)
  HOSTNAME = Rails.application.secrets.spid_hostname
  ACS_INDEX = Rails.application.secrets.spid_acs_index
  SLO_INDEX = Rails.application.secrets.spid_slo_index
  
  config.acs = ACS
  config.slo = SLO 

  config.acs_index = ACS_INDEX
  config.slo_index = SLO_INDEX
  
  config.hostname = HOSTNAME
  
  config.acs_binding = ACS[ACS_INDEX][:acs_binding] 
  config.slo_binding = SLO[SLO_INDEX][:slo_binding]
  
  config.acs_path = ACS[ACS_INDEX][:acs_url].gsub(HOSTNAME, "")
  config.slo_path = SLO[SLO_INDEX][:slo_url].gsub(HOSTNAME, "")
  
  config.entity_id = Rails.application.secrets.spid_entity_id
  config.idp_metadata_dir_path = Rails.root.join('config', 'idp_metadata')
  config.private_key_pem = File.read(Rails.root.join('lib', '.keys', 'private_key.pem'))
  config.certificate_pem = File.read(Rails.root.join('lib', '.keys', 'certificate.pem'))

  config.metadata_path = Rails.application.secrets.spid_metadata_path
  config.login_path = Rails.application.secrets.spid_login_path
  config.logout_path = Rails.application.secrets.spid_logout_path
  
  config.default_relay_state_path = Rails.application.secrets.spid_default_relay_state_path
  config.signature_method = Rails.application.secrets.spid_signature_method.constantize
  
  config.organization_name = Rails.application.secrets.spid_organization_name
  config.organization_display_name = Rails.application.secrets.spid_organization_display_name
  config.organization_url = Rails.application.secrets.spid_organization_url

  config.attribute_services = YAML::load(File.open("#{Rails.root}/config/spid_attr_serv_list.yml"))["attr_serv_list"].each(&:deep_symbolize_keys!)
  config.signed_metadata_path = Rails.root.join('config', 'signed_sp_metadata', 'metadata-signed.xml')
end
Spid.configuration.logger = Rails.logger
SpidAccessLogger.logger = Logger.new(SpidAccessLogger::LogFile)
SpidAccessLogger.logger.level = 'info' # could be debug, info, warn, error or fatal

