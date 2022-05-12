# frozen_string_literal: true
# This migration comes from decidim_consultations (originally 20190708121643)

class AddResponseGroupsToDecidimConsultationsResponses < ActiveRecord::Migration[5.2]
  def change
    add_reference :decidim_consultations_responses,
                  :decidim_consultations_response_group,
                  foreign_key: true,
                  index: { name: "index_consultations_response_groups_on_consultation_responses" }
  end
end
