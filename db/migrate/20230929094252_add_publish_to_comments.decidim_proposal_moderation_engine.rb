# This migration comes from decidim_proposal_moderation_engine (originally 20220607103408)
class AddPublishToComments < ActiveRecord::Migration[6.0]
  def up
    add_column :decidim_comments_comments, :published_at, :datetime
    add_column :decidim_comments_comments, :state, :string

  end

  def down
    remove_column :decidim_comments_comments, :published_at, :datetime
    remove_column :decidim_comments_comments, :state, :string
  end
end
