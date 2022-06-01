# frozen_string_literal: true
# This migration comes from decidim_comparative_stats (originally 20191219104548)

class CreateDecidimComparativeStatsEndpoints < ActiveRecord::Migration[5.2]
  def change
    create_table :decidim_comparative_stats_endpoints do |t|
      t.string :endpoint
      t.boolean :active
      t.references :decidim_organization, null: false, foreign_key: true, index: { name: "decidim_comparative_stats_constraint_organization" }

      t.timestamps
    end
  end
end
