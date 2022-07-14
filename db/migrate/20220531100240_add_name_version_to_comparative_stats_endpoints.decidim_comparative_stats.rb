# frozen_string_literal: true
# This migration comes from decidim_comparative_stats (originally 20200122072955)

class AddNameVersionToComparativeStatsEndpoints < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_comparative_stats_endpoints, :name, :string
    add_column :decidim_comparative_stats_endpoints, :version, :string
  end
end
