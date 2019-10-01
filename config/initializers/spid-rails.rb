# frozen_string_literal: true

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
end
