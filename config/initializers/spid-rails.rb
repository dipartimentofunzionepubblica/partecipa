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
#require "#{Rails.root}/lib/spid/lib/spid/saml2/xml_signature.rb"
require "#{Rails.root}/lib/spid/lib/spid/slo/response.rb"
require "#{Rails.root}/lib/spid/lib/spid/sso/request.rb"
require "#{Rails.root}/lib/spid/lib/spid/sso/response.rb"
require "#{Rails.root}/lib/spid/lib/spid/identity_provider_manager.rb"
require "#{Rails.root}/lib/spid/lib/spid/configuration.rb"
require "#{Rails.root}/lib/spid/lib/spid/version.rb"
require "#{Rails.root}/lib/spid/saml2.rb"
require "#{Rails.root}/lib/spid/lib/spid.rb"
require "#{Rails.root}/lib/spid_access_logger/spid_access_logger.rb"



Spid.configure do |config|
  ACS = YAML::load(File.open("#{Rails.root}/config/acs_list.yml"))["acs_list"].each(&:deep_symbolize_keys!)
  SLO = YAML::load(File.open("#{Rails.root}/config/slo_list.yml"))["slo_list"].each(&:deep_symbolize_keys!)
  
  acs_index = Rails.application.secrets.spid_acs_index
  slo_index = Rails.application.secrets.spid_slo_index
  
  hostname = Rails.application.secrets.spid_hostname
  
  config.hostname = hostname
  config.entity_id = Rails.application.secrets.spid_entity_id

  config.idp_metadata_dir_path = Rails.root.join('config', 'idp_metadata')
  config.private_key_pem = File.read(Rails.root.join('lib', '.keys', 'private_key.pem'))
  config.certificate_pem = File.read(Rails.root.join('lib', '.keys', 'certificate.pem'))

  config.metadata_path = Rails.application.secrets.spid_metadata_path
  config.login_path = Rails.application.secrets.spid_login_path
  config.logout_path = Rails.application.secrets.spid_logout_path
  
  config.default_relay_state_path = Rails.application.secrets.spid_default_relay_state_path
  
  config.digest_method = Rails.application.secrets.spid_digest_method.constantize
  config.signature_method = Rails.application.secrets.spid_signature_method.constantize
  
  config.acs_binding = Rails.application.secrets.spid_acs_binding.constantize
  config.slo_binding = Rails.application.secrets.spid_slo_binding.constantize
  
  config.attribute_services = [
    { name: 'Decidim', fields: [:spid_code, :email] },
	{ name: 'Step One Authentication', fields: [:expiration_date, :address, :mobile_phone, :company_name, :iva_code, :place_of_birth, :gender, :name, :spid_code, :fiscal_number, :family_name, :date_of_birth, :county_of_birth, :id_card, :registered_office, :email, :digital_address] }
  ]

  config.organization_name = Rails.application.secrets.spid_organization_name
  config.organization_display_name = Rails.application.secrets.spid_organization_display_name
  config.organization_url = Rails.application.secrets.spid_organization_url
=begin 
  config.acs = [
	{acs_url: "https://partecipa.gov.it/spid/samlsso", acs_binding: "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST" },
    {acs_url: "https://partecipa.formez.org/spid/samlsso", acs_binding: "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST" }, 
	{acs_url: "https://www.ripam.cloud/api/spid/login", acs_binding: "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST"},
	{acs_url: "http://test_spid_decidim/spid/samlsso", acs_binding: "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST" }
  ] 
  
  config.slos = [
    {slo_url: "https://partecipa.gov.it/spid/samlslo", slo_binding: "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect", response_location: "https://partecipa.gov.it"},
	{slo_url: "https://partecipa.formez.org/spid/samlslo", slo_binding: "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect", response_location: "https://partecipa.formez.org"}, 
	{slo_url: "https://www.ripam.cloud/api/spid/logout", slo_binding: "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST"},
	{slo_url: "http://test_spid_decidim/spid/samlslo", slo_binding: "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect", response_location: "http://test_spid_decidim"}
  ] 
=end  

  config.acs = ACS
  config.slo = SLO 

  config.acs_index = acs_index
  config.slo_index = slo_index
  
  config.signed_metadata_path = Rails.root.join('config', 'signed_sp_metadata', 'metadata-signed.xml')
  
  Rails.logger.info ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" + ACS.inspect
  Rails.logger.info ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" + SLO.inspect
  
  Rails.logger.info ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" + acs_index.to_s
  Rails.logger.info ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" + slo_index.to_s
  
  Rails.logger.info ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" + ACS[acs_index][:acs_url].gsub(hostname, "")
  Rails.logger.info ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" + SLO[slo_index][:slo_url].gsub(hostname, "")
  
  
  config.acs_path = ACS[acs_index][:acs_url].gsub(hostname, "") 
  config.slo_path = SLO[slo_index][:slo_url].gsub(hostname, "") 
end
Spid.configuration.logger = Rails.logger
SpidAccessLogger.logger = Logger.new(SpidAccessLogger::LogFile)
SpidAccessLogger.logger.level = 'info' # could be debug, info, warn, error or fatal

