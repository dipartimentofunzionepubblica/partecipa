desc "Cleanup application logs older than 30 days"
task :logs => :environment do
  require 'fileutils'
  Dir.glob("#{Rails.root}/log/*.log.*").
    select{|f| File.mtime(f) < (Time.now - (60*60*24*30)) }. # older than 30 days
    each { |f| 
      puts "Removing #{f}"
      FileUtils.rm f 
    }
end
