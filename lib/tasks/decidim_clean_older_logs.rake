# frozen_string_literal: true

# Copyright (C) 2025 Formez PA
#
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>
#
# Inserito per gestire l'eliminazione dei log più vecchi di 30 giorni e comprimere in tar.gz i log più vecchi di un giorno

require 'fileutils'
require 'zlib'

namespace :decidim do
  namespace :clean do
   desc "Cleanup application logs older than 30 days"
   task :logs => :environment do
     Dir.glob("#{Rails.root}/log/*.log.*").
     select{|f| File.mtime(f) < (Time.now - (60*60*24*30)) }. # older than 30 days
     each { |f| 
        Rails.logger.info "-- Cleanup logs -- Removing #{f}"
        FileUtils.rm f 
     }
     
     Dir.glob("#{Rails.root}/log/*.log.*").
     select{|f| File.mtime(f) < (Time.now - (60*60*24*2)) }. # older than 1 day
      each { |f| 
        Rails.logger.info "-- Cleanup logs -- Compressing #{f}"
        compress_file f
        FileUtils.rm f
     }
   end
  
   def compress_file(file_name)
     zipped = "#{file_name}.gz"
     Zlib::GzipWriter.open(zipped) do |gz|
       gz.write IO.binread(file_name)
     end
   end
  
  end
end