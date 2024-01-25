# frozen_string_literal: true

# Copyright (C) 2023 Formez PA
#
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>
#
# Modificato per supportare l'ordine ascendente anziché discendente dei Meetings

module Decidim
  module Meetings
    module Admin
      # This controller is the abstract class from which all other controllers of
      # this engine inherit.
      #
      # Note that it inherits from `Decidim::Components::BaseController`, which
      # override its layout and provide all kinds of useful methods.
      class ApplicationController < Decidim::Admin::Components::BaseController
        helper Decidim::ApplicationHelper
        helper_method :meetings, :meeting, :maps_enabled?

        def meetings
          @meetings ||= Meeting.not_hidden.where(component: current_component).order(start_time: :asc).page(params[:page]).per(15)
        end

        def meeting
          @meeting ||= meetings.find(params[:id]) if params[:id]
        end

        def maps_enabled?
          @maps_enabled ||= current_component.settings.maps_enabled?
        end
      end
    end
  end
end
