# frozen_string_literal: true
# This migration comes from decidim_elections (originally 20200910103648)

class AddMinSelectionsToDecidimElectionsQuestions < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_elections_questions, :min_selections, :integer, null: false, default: 1
  end
end
