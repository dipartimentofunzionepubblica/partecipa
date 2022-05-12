# frozen_string_literal: true
# This migration comes from decidim_consultations (originally 20180320100658)

class AddIntroductoryImageToDecidimConsultations < ActiveRecord::Migration[5.1]
  def change
    add_column :decidim_consultations, :introductory_image, :string
  end
end
