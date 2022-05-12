# frozen_string_literal: true
# This migration comes from decidim_consultations (originally 20180122113447)

class AddOriginStringToDecidimConsultationsQuestions < ActiveRecord::Migration[5.1]
  def change
    add_column :decidim_consultations_questions, :origin_url, :string
  end
end
