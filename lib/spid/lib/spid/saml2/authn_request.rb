# frozen_string_literal: true

require 'rexml/document'
module Spid
  module Saml2
    class AuthnRequest # :nodoc:
      attr_reader :document
      attr_reader :settings

      def initialize(uuid: nil, settings:)
        @document = REXML::Document.new
        @uuid = uuid
        @settings = settings
      end

      def to_saml
        document.add_element(authn_request)
        document.to_s
      end

      def authn_request
        @authn_request ||=
          begin
            element = REXML::Element.new('samlp:AuthnRequest')
            element.add_attributes(authn_request_attributes)
            element.add_element(issuer)
            element.add_element(name_id_policy)
            element.add_element(requested_authn_context)
            element
          end
      end

      def authn_request_attributes
        @authn_request_attributes ||=
          begin
            attributes = {
              'xmlns:samlp' => 'urn:oasis:names:tc:SAML:2.0:protocol',
              'xmlns:saml' => 'urn:oasis:names:tc:SAML:2.0:assertion',
              'ID' => uuid,
              'Version' => '2.0',
              'IssueInstant' => issue_instant,
              'Destination' => settings.idp_sso_target_url,
              'AssertionConsumerServiceIndex' => settings.acs_index,
              'AttributeConsumingServiceIndex' => settings.attribute_index
            }
            attributes['ForceAuthn'] = true if settings.force_authn?
            attributes
          end
      end

      def issuer
        @issuer ||=
          begin
            element = REXML::Element.new('saml:Issuer')
            element.add_attributes(
              'Format' => 'urn:oasis:names:tc:SAML:2.0:nameid-format:entity',
              'NameQualifier' => settings.sp_entity_id
            )
            element.text = settings.sp_entity_id
            element
          end
      end

      def name_id_policy
        @name_id_policy ||=
          begin
            element = REXML::Element.new('samlp:NameIDPolicy')
            element.add_attributes(
              'Format' => 'urn:oasis:names:tc:SAML:2.0:nameid-format:transient'
            )
            element
          end
      end

      def requested_authn_context
        @requested_authn_context ||=
          begin
            element = REXML::Element.new('samlp:RequestedAuthnContext')
            element.add_attributes(
              'Comparison' => Spid::MINIMUM_COMPARISON
            )
            element.add_element(authn_context_class_ref)
            element
          end
      end

      def authn_context_class_ref
        @authn_context_class_ref ||=
          begin
            element = REXML::Element.new('saml:AuthnContextClassRef')
            element.text = settings.authn_context
            element
          end
      end

      def issue_instant
        @issue_instant ||= Time.now.utc.iso8601
      end

      def uuid
        @uuid ||= "_#{SecureRandom.uuid}"
      end
    end
  end
end
