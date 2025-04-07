# frozen_string_literal: true

#
# Copyright (C) 2023 Formez PA
#
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# Modificato per visualizzare sempre tutti i processi nella pagina Processi e non solo quelli attivi per default e in modo da separare Processi attivi e conclusi in due sezioni di pagina diverse
module Decidim
  module ParticipatoryProcesses
    # A controller that holds the logic to show ParticipatoryProcesses in a
    # public layout.
    class ParticipatoryProcessesController < Decidim::ParticipatoryProcesses::ApplicationController
      include ParticipatorySpaceContext
      participatory_space_layout only: [:show, :all_metrics]
      include FilterResource

      helper_method :collection,
                    :promoted_collection,
                    :participatory_processes,
                    :stats,
                    :metrics,
                    :participatory_process_group,
                    :default_date_filter,
                    :related_processes,
                    :linked_assemblies,
                    :active_collection,
                    :ended_collection,
                    :upcoming_collection

      def index
        raise ActionController::RoutingError, "Not Found" if published_processes.none?

        enforce_permission_to :list, :process
        enforce_permission_to :list, :process_group
      end

      def show
        enforce_permission_to :read, :process, process: current_participatory_space
      end

      def all_metrics
        if current_participatory_space.show_statistics
          enforce_permission_to :read, :process, process: current_participatory_space
        else
          render status: :not_found
        end
      end

      private

      def search_collection
        ParticipatoryProcess.where(organization: current_organization).published.visible_for(current_user).includes(:area)
      end

      def default_filter_params
        {
          with_any_scope: nil,
          with_area: nil,
          with_type: nil,
          with_date: default_date_filter
        }
      end

      def organization_participatory_processes
        @organization_participatory_processes ||= OrganizationParticipatoryProcesses.new(current_organization).query
      end

      def current_participatory_space
        return unless params["slug"]

        @current_participatory_space ||= organization_participatory_processes.where(slug: params["slug"]).or(
          organization_participatory_processes.where(id: params["slug"])
        ).first!
      end

      def published_processes
        @published_processes ||= OrganizationPublishedParticipatoryProcesses.new(current_organization, current_user)
      end

      def promoted_participatory_processes
        @promoted_participatory_processes ||= published_processes | PromotedParticipatoryProcesses.new
      end

      def promoted_participatory_process_groups
        @promoted_participatory_process_groups ||= OrganizationPromotedParticipatoryProcessGroups.new(current_organization)
      end

      def promoted_collection
        @promoted_collection ||= promoted_participatory_processes.query + promoted_participatory_process_groups.query
      end

      def collection
        @collection ||= participatory_processes + participatory_process_groups
      end

      def active_collection
        @active_collection ||= participatory_processes.select{|process| process.active?}
      end

      def ended_collection
        @ended_collection ||= participatory_processes.select{|process| !process.active? && !process.upcoming?}
      end

      def upcoming_collection
        @upcoming_collection ||= participatory_processes.select{|process| process.upcoming?}
      end

      def filtered_processes
        search.result
      end

      def participatory_processes
        @participatory_processes ||= filtered_processes
      end

      def participatory_process_groups
        @participatory_process_groups ||= OrganizationParticipatoryProcessGroups.new(current_organization).query
                                                                                .where(id: filtered_processes.grouped.group_ids)
      end

      def stats
        @stats ||= ParticipatoryProcessStatsPresenter.new(participatory_process: current_participatory_space)
      end

      def metrics
        @metrics ||= ParticipatoryProcessMetricChartsPresenter.new(participatory_process: current_participatory_space, view_context: view_context)
      end

      def participatory_process_group
        @participatory_process_group ||= current_participatory_space.participatory_process_group
      end

      def default_date_filter
        return "active" if published_processes.any?(&:active?)
        return "upcoming" if published_processes.any?(&:upcoming?)
        return "past" if published_processes.any?(&:past?)

        "all"
      end

      def related_processes
        @related_processes ||=
          current_participatory_space
          .linked_participatory_space_resources(:participatory_processes, "related_processes")
          .published
          .all
      end

      def linked_assemblies
        @linked_assemblies ||= current_participatory_space.linked_participatory_space_resources(:assembly, "included_participatory_processes").public_spaces
      end
    end
  end
end