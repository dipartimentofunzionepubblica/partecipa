# frozen_string_literal: true

require 'spid/saml2/utils'
require 'active_support/inflector/methods'
module Spid
  module Sso
    class Response # :nodoc:
      include Spid::Saml2::Utils

      attr_reader :body
      attr_reader :saml_message
      attr_reader :request_uuid
      attr_reader :authn_issue_instant
      attr_reader :acs_url
      attr_reader :authn_context

      def initialize(body:, request_uuid:, authn_issue_instant:, acs_url:, authn_context:)
        @body = body
        @saml_message = decode_and_inflate(body)
        @request_uuid = request_uuid
        @authn_issue_instant = authn_issue_instant
        @acs_url = acs_url
        @authn_context = authn_context
      end

      def valid?
        validator.call
      end

      def validator
        @validator ||=
          Spid::Saml2::ResponseValidator.new(
            response: saml_response,
            settings: settings,
            request_uuid: request_uuid,
            authn_issue_instant: authn_issue_instant,
            acs_url: acs_url,
            authn_context: authn_context
          )
      end

      def issuer
        saml_response.assertion_issuer || 'default'
      end

      def errors
        validator.errors
      end

      def attributes
        raw_attributes.each_with_object({}) do |(key, value), acc|
          acc[normalize_key(key)] = value
        end
      end

      def session_index
        saml_response.session_index
      end

      def raw_attributes
        saml_response.attributes
      end

      def identity_provider
        @identity_provider ||=
          IdentityProviderManager.find_by_entity(issuer)
      end

      def service_provider
        @service_provider ||=
          Spid.configuration.service_provider
      end

      def saml_response
        @saml_response ||= Spid::Saml2::Response.new(saml_message: saml_message)
      end

      def settings
        @settings ||= Spid::Saml2::Settings.new(
          identity_provider: identity_provider,
          service_provider: service_provider
        )
      end

      private

      def normalize_key(key)
        ActiveSupport::Inflector.underscore(
          key.to_s
        ).to_s
      end
    end
  end
end
