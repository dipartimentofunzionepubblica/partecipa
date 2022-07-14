# frozen_string_literal: true
# This migration comes from decidim_comparative_stats (originally 20200130203914)

class RenameVersionFieldInComparativeStatsEndpoints < ActiveRecord::Migration[5.2]
  def change
    rename_column :decidim_comparative_stats_endpoints, :version, :api_version
  end
end
