# frozen_string_literal: true
# This migration comes from decidim_consultations (originally 20180126142459)

class AddEnableHighlightedBannerToDecidimConsultations < ActiveRecord::Migration[5.1]
  def change
    add_column :decidim_consultations, :enable_highlighted_banner, :boolean, null: false, default: true
  end
end
