# frozen_string_literal: true
# This migration comes from decidim_consultations (originally 20200320105916)

class IndexForeignKeysInDecidimConsultationsVotes < ActiveRecord::Migration[5.2]
  def change
    add_index :decidim_consultations_votes, :decidim_user_group_id
  end
end
