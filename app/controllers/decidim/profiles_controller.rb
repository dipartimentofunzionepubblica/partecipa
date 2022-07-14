# frozen_string_literal: true

# Copyright (C) 2020 Formez PA
#
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>
#
# Modificato per permettere la visualizzazione del profilo utente solo al proprietario dello stesso

module Decidim
  # The controller to handle the user's public profile page.
  class ProfilesController < Decidim::ApplicationController
    include UserGroups
    include Flaggable

    helper Decidim::Messaging::ConversationHelper
    helper_method :profile_holder, :active_content

    before_action :ensure_profile_holder
    before_action :ensure_profile_holder_is_a_group, only: [:members]
    before_action :ensure_profile_holder_is_a_user, only: %i[groups following]
    before_action :ensure_user_not_blocked, only: %i[following followers badges]
    before_action :ensure_profile_holder_is_current_user, only: %i[following followers groups]

    def show
      return redirect_to profile_timeline_path(nickname: params[:nickname]) if profile_holder == current_user
      return redirect_to profile_members_path if profile_holder.is_a?(Decidim::UserGroup)

      redirect_to profile_activity_path(nickname: params[:nickname])
    end

    def following
      @content_cell = 'decidim/following'
      @title_key = 'following'
      render :show
    end

    def followers
      @content_cell = 'decidim/followers'
      @title_key = 'followers'
      render :show
    end

    def badges
      @content_cell = 'decidim/badges'
      @title_key = 'badges'
      render :show
    end

    def groups
      enforce_user_groups_enabled

      @content_cell = 'decidim/groups'
      @title_key = 'groups'
      render :show
    end

    def members
      enforce_user_groups_enabled

      @content_cell = 'decidim/members'
      @title_key = 'members'
      render :show
    end

    def activity
      @content_cell = 'decidim/user_activity'
      @title_key = 'activity'
      render :show
    end

    private

    def ensure_user_not_blocked
      raise ActionController::RoutingError, 'Blocked User' if profile_holder&.blocked? && !current_user&.admin?
    end

    def ensure_profile_holder_is_a_group
      raise ActionController::RoutingError, 'No user group with the given nickname' unless profile_holder.is_a?(Decidim::UserGroup)
    end

    def ensure_profile_holder_is_a_user
      raise ActionController::RoutingError, 'No user with the given nickname' unless profile_holder.is_a?(Decidim::User)
    end

    def ensure_profile_holder
      raise ActionController::RoutingError, 'No user or user group with the given nickname' if !profile_holder || profile_holder.nickname.blank?
    end

    def ensure_profile_holder_is_current_user
      raise ActionController::RoutingError, 'Not Found' if current_user != @profile_holder
    end

    def profile_holder
      return if params[:nickname].blank?

      @profile_holder ||= Decidim::User.find_by(
        nickname: params[:nickname],
        organization: current_organization
      ) || Decidim::UserGroup.find_by(
        nickname: params[:nickname],
        organization: current_organization
      )
    end
  end
end
