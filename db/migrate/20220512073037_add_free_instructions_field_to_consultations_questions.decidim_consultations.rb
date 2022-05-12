# frozen_string_literal: true
# This migration comes from decidim_consultations (originally 20190710121122)

class AddFreeInstructionsFieldToConsultationsQuestions < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_consultations_questions, :instructions, :jsonb
  end
end
