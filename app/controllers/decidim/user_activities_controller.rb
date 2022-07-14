# frozen_string_literal: true

# Copyright (C) 2022 Formez PA
#
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>
#
#
# Modificato per rendere possibile la visualizzazione della propria attività solo al proprietario del profilo e agli admin per moderazione

module Decidim
  # The controller to show all the last activities in a Decidim Organization.
  class UserActivitiesController < Decidim::ApplicationController
    include Paginable
    include UserGroups
    include FilterResource
    include Flaggable
    include Decidim::UserProfile

    helper Decidim::ResourceHelper
    helper_method :activities, :resource_types, :user, :current_user

    def index
      enforce_permission_to :user, current_user: current_user
      raise ActionController::RoutingError, 'Blocked User' if user&.blocked? && !current_user&.admin?
      raise ActionController::RoutingError, 'Not Found' if current_user != user && !current_user.admin?
    end

    private

    def user
      @user ||= current_organization.users.find_by(nickname: params[:nickname])
    end

    def activities
      @activities ||= paginate(
        ActivitySearch.new(
          organization: current_organization,
          user: user,
          resource_type: 'all',
          resource_name: filter.resource_type
        ).run
      )
    end

    def default_filter_params
      { resource_type: nil }
    end

    def resource_types
      @resource_types = %w[Decidim::Proposals::CollaborativeDraft
                           Decidim::Comments::Comment
                           Decidim::Debates::Debate
                           Decidim::Initiative
                           Decidim::Meetings::Meeting
                           Decidim::Blogs::Post
                           Decidim::Proposals::Proposal
                           Decidim::Consultations::Question]
    end
  end
end
