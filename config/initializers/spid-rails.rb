# frozen_string_literal: true

Spid.configure do |config|
  config.hostname = 'http://test_spid_decidim'

  config.idp_metadata_dir_path = Rails.root.join('config', 'idp_metadata')
  config.private_key_pem = File.read(Rails.root.join('lib', '.keys', 'private_key.pem'))
  config.certificate_pem = File.read(Rails.root.join('lib', '.keys', 'certificate.pem'))

  config.metadata_path = '/spid/metadata.xml'
  config.login_path = '/spid/login'
  config.logout_path = '/spid/logout'
  config.acs_path = '/spid/samlsso'
  config.slo_path = '/spid/samlsso'
  config.default_relay_state_path = '/users/auth/spidauth/callback'
  
  config.digest_method = Spid::SHA256
  config.signature_method = Spid::RSA_SHA256
  config.acs_binding = Spid::BINDINGS_HTTP_POST
  config.slo_binding = Spid::BINDINGS_HTTP_REDIRECT
  config.attribute_services = [
    { name: 'Decidim', fields: ['spid_code','email','name','family_name'] }
  ]
end
