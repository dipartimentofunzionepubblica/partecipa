# frozen_string_literal: true

# Copyright (C) 2022 Formez PA
#
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>
#
# Modificato per eseguire il task metrics immediatamente ed evitare che venga inserito in coda

namespace :decidim do
  namespace :metrics do
    # All ------
    #
    # Get all metrics entities and execute his own rake task.
    # It admits a date-string parameter, in a 'YYYY-MM-DD' format from
    # today to all past dates
    desc 'Execute all metrics calculation methods'
    task :all, [:day] => :environment do |_task, args|
      Decidim::Organization.find_each do |organization|
        Decidim.metrics_registry.all.each do |metric_manifest|
          call_metric_job(metric_manifest, organization, args.day)
        end
      end
    end

    # One ------
    #
    # Execute metric calculations for just one metric
    # It need a metric name and permits a date-string parameter, in a 'YYYY-MM-DD' format from
    # today to all past dates
    desc 'Execute one metric calculation method'
    task :one, %i[metric day] => :environment do |_task, args|
      next if args.metric.blank?

      Decidim::Organization.find_each do |organization|
        metric_manifest = Decidim.metrics_registry.for(args.metric)
        call_metric_job(metric_manifest, organization, args.day)
      end
    end

    desc 'Rebuild calculations from specific day'
    task :rebuild, %i[metric day] => :environment do |_task, args|
      metric = args.metric
      day = args.day
      if args.day.blank?
        day = args.metric
        metric = nil
      end
      begin
        raise ArgumentError if day.blank?

        (Date.parse(day)..Date.current).each do |d|
          current_day = d.to_s
          Decidim::Organization.find_each do |organization|
            if metric
              m_manifest = Decidim.metrics_registry.for(metric)
              log_info "[#{organization.name}]: rebuilding metric [#{metric}] for day [#{current_day}]"
              call_metric_job(m_manifest, organization, current_day)
            else
              log_info "[#{organization.name}]: rebuilding all metrics for day [#{current_day}]"
              Decidim.metrics_registry.all.each do |metric_manifest|
                call_metric_job(metric_manifest, organization, current_day)
              end
            end
          end
        end
      rescue ArgumentError
        log_error 'ERROR: Please specify since which date should the metrics be rebuild'
        log_error 'ie: rails decidim:metrics:rebuild[2019-01-01]'
      end
    end

    desc 'Show available metrics'
    task list: :environment do
      puts Decidim.metrics_registry.all.pluck :metric_name
    end

    def call_metric_job(metric_manifest, organization, day = nil)
      Decidim::MetricJob.perform_now(
        metric_manifest.manager_class,
        organization.id,
        day
      )
    end

    def log_info(msg)
      puts msg
      Rails.logger.info(msg)
    end

    def log_error(msg)
      puts msg
      Rails.logger.error(msg)
    end
  end
end
