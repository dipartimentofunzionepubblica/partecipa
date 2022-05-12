# frozen_string_literal: true
# This migration comes from decidim_elections (originally 20200601141412)

class AddPublishedAtToElections < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_elections_elections, :published_at, :datetime
  end
end
