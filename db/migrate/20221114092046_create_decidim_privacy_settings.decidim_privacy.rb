# This migration comes from decidim_privacy (originally 20220607103408)
class CreateDecidimPrivacySettings < ActiveRecord::Migration[6.0]
  def up
    create_table :decidim_privacy_settings do |t|
      t.references :decidim_organization, null: false, foreign_key: true, index: { name: "decidim_privacy_setting_organization" }
      t.references :decidim_user, index: { name: "decidim_privacy_setting_user" }
      t.boolean :user_avatar, default: true
      t.boolean :user_search, default: true
      t.boolean :user_follow, default: true
      t.boolean :user_index, default: true
      t.boolean :user_public_page, default: true
    end

    Decidim::Organization.all.each do |o|
      o.create_privacy_setting
    end
  end

  def down
    drop_table :decidim_privacy_settings
  end
end
