# This migration comes from decidim_privacy (originally 20220607103408)
# Copyright (C) 2022 Formez PA
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# Migrazione che genera la tabella sul database dei settings durante l'installazione

class CreateDecidimPrivacySettings < ActiveRecord::Migration[6.0]
  def up
    create_table :decidim_privacy_settings do |t|
      t.references :decidim_organization, null: false, foreign_key: true, index: { name: "decidim_privacy_setting_organization" }
      t.references :decidim_user, index: { name: "decidim_privacy_setting_user" }
      t.boolean :user_avatar, default: true
      t.boolean :user_search, default: true
      t.boolean :user_follow, default: true
      t.boolean :user_message, default: true
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
