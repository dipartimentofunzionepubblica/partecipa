# frozen_string_literal: true

# Copyright (C) 2021 Formez PA
#
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# frozen_string_literal: true

module Decidim
  # The controller to show all the last activities in a Decidim Organization.
  class UserActivitiesController < Decidim::ApplicationController
    include Paginable
    include UserGroups
	include FilterResource

    helper Decidim::ResourceHelper
    helper_method :activities, :resource_types, :user

    def index
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
          resource_type: 'all'
        ).run
      )
    end
	
	def default_filter_params
      { resource_type: nil }
    end

    def resource_types
      @resource_types = %w(Decidim::Proposals::CollaborativeDraft
                           Decidim::Comments::Comment
                           Decidim::Debates::Debate
                           Decidim::Initiative
                           Decidim::Meetings::Meeting
                           Decidim::Blogs::Post
                           Decidim::Proposals::Proposal
                           Decidim::Consultations::Question)
    end
  end
end