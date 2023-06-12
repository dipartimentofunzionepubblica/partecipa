# frozen_string_literal: true

# Copyright (C) 2022 Formez PA
#
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>
#
# Modificato per eseguire il task opendata immediatamente ed evitare che venga inserito in coda

namespace :decidim do
  namespace :open_data do
    desc 'Generates the Open Data export files for each organization.'
    task export: :environment do
      Decidim::Organization.find_each do |organization|
        Decidim::OpenDataJob.perform_now(organization)
      end
    end
  end
end
