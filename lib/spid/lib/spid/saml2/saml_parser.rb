# frozen_string_literal: true

require 'spid/saml2/utils'

module Spid
  module Saml2
    class SamlParser # :nodoc:
      include Spid::Saml2::Utils

      attr_reader :saml_message
      attr_reader :document

      def initialize(saml_message:)
        @saml_message = saml_message
        @document = REXML::Document.new(@saml_message)
      end

      def element_from_xpath(xpath)
        document.elements[xpath]&.value&.strip
      end

      def saml_or_saml2(xpath)
        xpath + ' | ' + xpath.gsub('samlp:', 'saml2p:').gsub('saml:', 'saml2:')
      end
    end
  end
end
