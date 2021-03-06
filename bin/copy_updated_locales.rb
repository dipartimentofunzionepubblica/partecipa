require 'fileutils'
require File.expand_path('../../config/environment', __FILE__)

class CopyUpdatedLocales
	GEM_FOLDER = Gem.dir + "/gems"
	LOCAL_REPO_FOLDER = Rails.root.join("tmp", "decidim_repo") 
	LAST_VERSION = "0.19.0"
	LOCALES_RELATIVE_PATH = "config/locales"
	ITALIAN_YML_FILENAME = "it.yml"
	ENGLISH_YML_FILENAME = "en.yml"
	LOCALES_YML_FILES = [ITALIAN_YML_FILENAME, ENGLISH_YML_FILENAME]

	def initialize
		decidim_engines =
		[
			"decidim-accountability",
			"decidim-admin",
			"decidim-assemblies",
			"decidim-blogs",
			"decidim-budgets",
			"decidim-comments",
			"decidim-core",
			"decidim-debates",
			"decidim-dev",
			"decidim-forms",
			"decidim-generators",
			"decidim-meetings",
			"decidim-pages",
			"decidim-participatory_processes",
			"decidim-proposals",
			"decidim-sortitions",
			"decidim-surveys",
			"decidim-system",
			"decidim-verifications"
		]
		LOCALES_YML_FILES.each do |locale_yml_file|
			decidim_engines.each  do |engine|
				result = rename_file(GEM_FOLDER + "/" + engine + "-" + LAST_VERSION + "/" + LOCALES_RELATIVE_PATH + "/" + locale_yml_file)
				if result then
					copy_file(LOCAL_REPO_FOLDER.to_s + "/" + engine + "/" + LOCALES_RELATIVE_PATH + "/" + locale_yml_file,  GEM_FOLDER + "/" + engine + "-" + LAST_VERSION + "/" + LOCALES_RELATIVE_PATH + "/" + locale_yml_file)
				end
			end
		end
	end

	def rename_file(file)
		begin
			puts "rename_file path: " + file
			time = Time.now.to_formatted_s(:db).to_s.gsub(' ', '_')
			File.rename(file, file + "_OLD_" + time)
			return true
		rescue Errno::ENOENT => e
			puts "Error in renaming file " +  file + " NOT FOUND: removing engine from list. Message: " + e.message
			return false
		end
	end

	def copy_file(source_file, dest_path)
		begin
			puts "copy_file source_file: " + source_file.to_s + " destination path: " + dest_path
			FileUtils.cp(source_file, dest_path)
		rescue StandardError => e
			puts "Error in copying file: " + source_file.to_s + " to destination path: " + dest_path + ". Message: " + e.message
		end
	end
end

cul = CopyUpdatedLocales.new
