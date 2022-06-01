# frozen_string_literal: true

module Spid
  module Sso
    class Request # :nodoc:
      attr_reader :idp_name
      attr_reader :relay_state
      attr_reader :attribute_index
      attr_reader :authn_context
      attr_reader :authn_context_comparison

      def initialize(
        idp_name:,
        attribute_index:,
        relay_state: nil,
        authn_context: nil
      )
        @idp_name = idp_name
        @relay_state = relay_state
        @authn_context = authn_context || Spid::L1
        @attribute_index = attribute_index
        @relay_state =
          begin
            relay_state || Spid.configuration.default_relay_state_path
          end
      end

      def url
        [
          settings.idp_sso_target_url,
          query_params_signer.escaped_signed_query_string
        ].join('?')
      end

      def uuid
        authn_request.uuid
      end

      def authn_issue_instant
        authn_request.issue_instant
      end

      def acs_url
        settings.sp_acs_url
      end

      def query_params_signer
        @query_params_signer ||=
          begin
            Spid::Saml2::Utils::QueryParamsSigner.new(
              saml_message: saml_message,
              relay_state: relay_state,
              private_key: settings.private_key,
              signature_method: settings.signature_method
            )
          end
      end

      def saml_message
        @saml_message ||= authn_request.to_saml
      end

      def authn_request
        @authn_request ||= Spid::Saml2::AuthnRequest.new(settings: settings)
      end

      def settings
        @settings ||= Spid::Saml2::Settings.new(
          identity_provider: identity_provider,
          service_provider: service_provider,
          authn_context: authn_context,
          attribute_index: attribute_index
        )
      end

      def identity_provider
        @identity_provider ||=
          IdentityProviderManager.find_by_entity(idp_name)
      end

      def service_provider
        @service_provider ||=
          Spid.configuration.service_provider
      end
    end
  end
end
