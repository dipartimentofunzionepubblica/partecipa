require 'fileutils'

class CopyUpdatedLocales
	GEM_FOLDER = "/home/decidim/.rbenv/versions/2.6.2/lib/ruby/gems/2.6.0/gems/"
	LOCAL_REPO_FOLDER = "/home/decidim/decidim-app/tmp/decidim_repo/"
	LAST_VERSION = "0.17.0"
	DECIDIM_ENGINES =
	[
		"decidim-accountability",
		#"decidim-admin",
		"decidim-assemblies",
		"decidim-blogs",
		"decidim-budgets",
		"decidim-comments",
		#"decidim-core",
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
	 #"decidim-api",
	LOCALES_RELATIVE_PATH = "/config/locales/"

	def initialize
		DECIDIM_ENGINES.each  do |engine|
			rename_file(GEM_FOLDER + engine + "-" + LAST_VERSION + LOCALES_RELATIVE_PATH + "it.yml")
		end
		DECIDIM_ENGINES.each  do |engine|
			copy_file(LOCAL_REPO_FOLDER + engine + LOCALES_RELATIVE_PATH + "it.yml",  GEM_FOLDER + engine + "-" + LAST_VERSION + LOCALES_RELATIVE_PATH + "it.yml")
		end
	end

	def rename_file(file)
		begin
			puts "path = " + file
			File.rename(file, file + "_OLD")
		rescue Errno::ENOENT => e
			puts file + " NOT FOUND"
		end
	end

	def copy_file(source_file, dest_folder)
		begin
			puts "path = " + dest_folder
			FileUtils.cp(source_file, dest_folder)
		rescue StandardError => e
			puts e.message
		end
	end
end

cul = CopyUpdatedLocales.new
