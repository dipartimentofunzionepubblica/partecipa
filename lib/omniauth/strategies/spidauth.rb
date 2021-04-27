# frozen_string_literal: true

# Copyright (C) 2020 Formez PA
#
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

require 'omniauth'

module OmniAuth
  module Strategies
    class Spidauth
      include OmniAuth::Strategy
      include Spid::Rails::RouteHelper

      def request_phase
        idp_param = request.params['idp_param']
        attribute_service_index = Rails.application.secrets.spid_attr_serv_list_index || 0
        authn_context = Rails.application.secrets.spid_level.constantize || Spid::L1
        redirect spid_login_path(idp_name: idp_param, authn_context: authn_context, attribute_service_index: attribute_service_index) if idp_param.present?
      end

      def callback_phase
        if !session.nil? && !session[:spid]['session_index'].blank? && !session[:spid]['attributes'].blank?
          @provider = session[:spid]['idp']
          @uid = session[:spid]['attributes']['spid_code']
          @email = session[:spid]['attributes']['email']
          auth_hash
          super
        elsif !session[:spid]['errors'].blank?
          @errors = session[:spid]['errors']
          auth_hash
          super
        end
      end

      def auth_hash
        OmniAuth::Utils.deep_merge(super(),
                                   'provider' => @provider,
                                   'uid' => @uid,
                                   'user_info' => {
                                     'email'	=> @email
                                   },
                                   'extra' => {
                                     'raw_info' => @errors
                                   })
      end

      def authorize_params
        super.merge(idp_param: request.params['idp_param'])
      end
    end
  end
end
