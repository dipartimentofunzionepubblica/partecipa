# frozen_string_literal: true

require 'base64'
require 'zlib'
require 'cgi'
require 'net/http'
require 'net/https'
require 'rexml/document'
require 'rexml/xpath'

# Only supports SAML 2.0
module Spid
  module Saml2
    include REXML

    # Auxiliary class to retrieve and parse the Identity Provider Metadata
    #
    class IdpMetadataParser
      METADATA       = 'urn:oasis:names:tc:SAML:2.0:metadata'
      DSIG           = 'http://www.w3.org/2000/09/xmldsig#'
      NAME_FORMAT    = 'urn:oasis:names:tc:SAML:2.0:attrname-format:*'
      SAML_ASSERTION = 'urn:oasis:names:tc:SAML:2.0:assertion'

      attr_reader :document
      attr_reader :response

      # Parse the Identity Provider metadata and return the results as Hash
      #
      # @param idp_metadata [String]
      #
      # @return [Hash]
      def parse_to_hash(idp_metadata)
        @document = REXML::Document.new(idp_metadata)
        @entity_descriptor = nil
        @certificates = nil

        {
          idp_entity_id: idp_entity_id,
          name_identifier_format: idp_name_id_format,
          idp_sso_target_url: single_signon_service_url,
          idp_slo_target_url: single_logout_service_url,
          idp_attribute_names: attribute_names,
          idp_cert: nil,
          idp_cert_multi: nil
        }.tap do |response_hash|
          merge_certificates_into(response_hash) unless certificates.nil?
        end
      end

      private

      def entity_descriptor
        @entity_descriptor ||= REXML::XPath.first(
          document,
          '//md:EntityDescriptor',
          namespace
        )
      end

      # @return [String|nil] IdP Entity ID value if exists
      #
      def idp_entity_id
        entity_descriptor.attributes['entityID']
      end

      # @return [String|nil] IdP Name ID Format value if exists
      #
      def idp_name_id_format
        node = REXML::XPath.first(
          entity_descriptor,
          'md:IDPSSODescriptor/md:NameIDFormat',
          namespace
        )
        element_text(node)
      end

      # @return [String|nil] SingleSignOnService binding if exists
      #
      def single_signon_service_binding
        nodes = REXML::XPath.match(
          entity_descriptor,
          'md:IDPSSODescriptor/md:SingleSignOnService/@Binding',
          namespace
        )
        nodes.first.value if nodes.any?
      end

      # @return [String|nil] SingleSignOnService endpoint if exists
      #
      def single_signon_service_url
        # binding = single_signon_service_binding
        binding = 'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect'
        unless binding.nil?
          node = REXML::XPath.first(
            entity_descriptor,
            "md:IDPSSODescriptor/md:SingleSignOnService[@Binding=\"#{binding}\"]/@Location",
            namespace
          )
          return node.value if node
        end
      end

      # @return [String|nil] SingleLogoutService binding if exists
      #
      def single_logout_service_binding
        nodes = REXML::XPath.match(
          entity_descriptor,
          'md:IDPSSODescriptor/md:SingleLogoutService/@Binding',
          namespace
        )
        nodes.first.value if nodes.any?
      end

      # @return [String|nil] SingleLogoutService endpoint if exists
      #
      def single_logout_service_url
        # binding = single_logout_service_binding
        binding = 'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect'
        unless binding.nil?
          node = REXML::XPath.first(
            entity_descriptor,
            "md:IDPSSODescriptor/md:SingleLogoutService[@Binding=\"#{binding}\"]/@Location",
            namespace
          )
          return node.value if node
        end
      end

      # @return [String|nil] Unformatted Certificate if exists
      #
      def certificates
        @certificates ||= begin
          signing_nodes = REXML::XPath.match(
            entity_descriptor,
            "md:IDPSSODescriptor/md:KeyDescriptor[not(contains(@use, 'encryption'))]/ds:KeyInfo/ds:X509Data/ds:X509Certificate",
            namespace
          )

          encryption_nodes = REXML::XPath.match(
            entity_descriptor,
            "md:IDPSSODescriptor/md:KeyDescriptor[not(contains(@use, 'signing'))]/ds:KeyInfo/ds:X509Data/ds:X509Certificate",
            namespace
          )

          certs = nil
          unless signing_nodes.empty? && encryption_nodes.empty?
            certs = {}
            unless signing_nodes.empty?
              certs['signing'] = []
              signing_nodes.each do |cert_node|
                certs['signing'] << element_text(cert_node)
              end
            end

            unless encryption_nodes.empty?
              certs['encryption'] = []
              encryption_nodes.each do |cert_node|
                certs['encryption'] << element_text(cert_node)
              end
            end
          end
          certs
        end
      end

      # @return [Array] the names of all SAML attributes if any exist
      #
      def attribute_names
        nodes = REXML::XPath.match(
          entity_descriptor,
          'md:IDPSSODescriptor/saml:Attribute/@Name',
          namespace
        )
        nodes.map(&:value)
      end

      def namespace
        {
          'md' => METADATA,
          'NameFormat' => NAME_FORMAT,
          'saml' => SAML_ASSERTION,
          'ds' => DSIG
        }
      end

      def merge_certificates_into(parsed_metadata)
        if certificates.key?('signing')
          certificate = certificates['signing'][0]
        else
          certificate = certificates['encryption'][0]
        end
        parsed_metadata[:idp_cert] = OpenSSL::X509::Certificate.new(
          Base64.decode64(certificate)
        )
      end

      def element_text(element)
        element.texts.map(&:value).join if element
      end
    end
  end
end
