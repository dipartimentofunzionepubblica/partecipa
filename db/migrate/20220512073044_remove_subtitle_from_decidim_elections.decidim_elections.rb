# frozen_string_literal: true
# This migration comes from decidim_elections (originally 20200807125040)

class RemoveSubtitleFromDecidimElections < ActiveRecord::Migration[5.2]
  def change
    remove_column :decidim_elections_elections, :subtitle
  end
end
