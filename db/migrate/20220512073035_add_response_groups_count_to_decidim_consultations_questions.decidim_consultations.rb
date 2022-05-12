# frozen_string_literal: true
# This migration comes from decidim_consultations (originally 20190708120345)

class AddResponseGroupsCountToDecidimConsultationsQuestions < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_consultations_questions, :response_groups_count, :integer, null: false, default: 0
  end
end
