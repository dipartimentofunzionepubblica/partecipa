# frozen_string_literal: true
# This migration comes from decidim_consultations (originally 20190702162755)

class AddOptionsToDecidimConsultationsQuestions < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_consultations_questions, :max_votes, :integer
    add_column :decidim_consultations_questions, :min_votes, :integer
  end
end
