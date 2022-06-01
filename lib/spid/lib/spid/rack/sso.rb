# frozen_string_literal: true

module Spid
  class Rack
    class Sso # :nodoc:
      attr_reader :app

      def initialize(app)
        @app = app
      end

      def call(env)
        @sso = SsoEnv.new(env)

        return @sso.response if @sso.valid_request?

        app.call(env)
      end

      class SsoEnv # :nodoc:
        attr_reader :env
        attr_reader :request

        def initialize(env)
          @env = env
          @request = ::Rack::Request.new(env)
          @relay_state = relay_state
        end

        def session
          request.session['spid']
        end

        def store_session_success
          session['attributes'] = responser.attributes
          session['session_index'] = responser.session_index
          session.delete('sso_request_uuid')
          session.delete('errors')
          session.delete('relay_state')
        end

        def store_session_failure
          session['errors'] = responser.errors
          session.delete('attributes')
          session.delete('sso_request_uuid')
          session.delete('session_index')
        end

        def response
          # log_message
          if valid_response?
            store_session_success
          else
            store_session_failure
          end
          [
            302, { 'Location' => @relay_state }, []
          ]
        end

        def saml_response
          request.params['SAMLResponse']
        end

        def relay_state_param
          request.params['RelayState']
        end

        def request_relay_state
          if !relay_state_param.nil? &&
             relay_state_param != '' &&
             !session['relay_state'].nil?
            session['relay_state'][relay_state_param]
          end
        end

        def relay_state
          if request_relay_state.nil?
            return Spid.configuration.default_relay_state_path
          end

          session['relay_state'][relay_state_param]
        end

        def valid_get?
          request.get? &&
            Spid.configuration.acs_binding == Spid::BINDINGS_HTTP_REDIRECT
        end

        def valid_post?
          request.post? &&
            Spid.configuration.acs_binding == Spid::BINDINGS_HTTP_POST
        end

        def valid_http_verb?
          valid_get? || valid_post?
        end

        def valid_path?
          request.path == Spid.configuration.acs_path
        end

        def valid_response?
          responser.valid?
        end

        def valid_request?
          valid_path? && valid_http_verb?
        end

        def responser
          @responser ||= ::Spid::Sso::Response.new(
            body: saml_response,
            request_uuid: session['sso_request_uuid'],
            authn_issue_instant: session['sso_request_issue_instant'],
            acs_url: session['sso_request_acs_url'],
            authn_context: session['sso_request_authn_context']
          )
        end

        def log_message
          return nil unless Spid.configuration.logging_enabled

          Spid.configuration.logger.info responser.saml_message.delete("\n")
        end
      end
    end
  end
end
