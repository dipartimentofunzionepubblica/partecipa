# frozen_string_literal: true

require 'base64'
module Spid
  class IdentityProviderManager # :nodoc:
    include Singleton

    def identity_providers
      @identity_providers ||=
        begin
          Dir.chdir(Spid.configuration.idp_metadata_dir_path) do
            Dir.glob('*.xml').map do |metadata_filepath|
              self.class.generate_identity_provider_from_file(
                File.expand_path(metadata_filepath)
              )
            end
          end
        end
    end

    def self.find_by_entity(entity_id)
      instance.identity_providers.find do |idp|
        idp.entity_id.include? entity_id
      end
    end

    def self.parse_from_xml(name:, metadata:)
      idp_metadata_parser = ::Spid::Saml2::IdpMetadataParser.new
      idp_settings = idp_metadata_parser.parse_to_hash(metadata)
      ::Spid::Saml2::IdentityProvider.new(
        name: name,
        entity_id: idp_settings[:idp_entity_id],
        sso_target_url: idp_settings[:idp_sso_target_url],
        slo_target_url: idp_settings[:idp_slo_target_url],
        certificate: idp_settings[:idp_cert]
      )
    end

    def self.generate_identity_provider_from_file(metadata_filepath)
      idp_name = File.basename(metadata_filepath, '-metadata.xml')
      metadata = File.read(metadata_filepath)
      parse_from_xml(
        metadata: metadata,
        name: idp_name
      )
    end
  end
end
