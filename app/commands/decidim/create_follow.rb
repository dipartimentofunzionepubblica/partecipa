# frozen_string_literal: true

# Copyright (C) 2021 Formez PA
#
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

module Decidim
  # A command with all the business logic for when a user starts following a resource.
  class CreateFollow < Rectify::Command
    # Public: Initializes the command.
    #
    # form         - A form object with the params.
    # current_user - The current user.
    def initialize(form, current_user)
      @form = form
      @current_user = current_user
    end

    # Executes the command. Broadcasts these events:
    #
    # - :ok when everything is valid, together with the follow.
    # - :invalid if the form wasn't valid and we couldn't proceed.
    #
    # Returns nothing.
    def call
      return broadcast(:invalid) if form.invalid?

      create_follow!
      increment_score
      broadcast(:ok, follow)
    end

    private

    attr_reader :follow, :form, :current_user

    def create_follow!
      @follow = Follow.find_by(
        followable: form.followable,
        user: current_user
      ) || Follow.create!(
        followable: form.followable,
        user: current_user
      )
    end

    def increment_score
      return unless form.followable.is_a? Decidim::User

      Decidim::Gamification.increment_score(form.followable, :followers)
    end
  end
end
