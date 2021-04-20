# frozen_string_literal: true

module Spid
  module Saml2
    class IdentityProvider # :nodoc:
      attr_reader :name
      attr_reader :entity_id
      attr_reader :sso_target_url
      attr_reader :slo_target_url
      attr_reader :certificate
      def initialize(
        name:,
        entity_id:,
        sso_target_url:,
        slo_target_url:,
        certificate:
      )
        @name = name
        @entity_id = entity_id
        @sso_target_url = sso_target_url
        @slo_target_url = slo_target_url
        @certificate = certificate
      end
    end
  end
end
