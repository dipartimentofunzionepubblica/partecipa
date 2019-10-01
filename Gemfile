# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

gem "decidim", "~> 0.18.0"
gem "decidim-conferences", "~> 0.18.0"
gem "bootsnap", "~> 1.3"
gem "puma", "~> 3.0"
gem "uglifier", "~> 4.1"
gem "faker", "~> 1.9"
gem "figaro"
gem "passenger"
gem 'delayed_job_active_record'
gem "daemons"
gem "pg"
gem "spid-rails", ">=  0.2.0"
gem "jquery-rails"
gem "omniauth"

group :development, :test do
  gem "byebug", "~> 10.0", platform: :mri
  gem "decidim-dev", "0.18.0"
end

group :development do
  gem "letter_opener_web", "~> 1.3"
  gem "listen", "~> 3.1"
  gem "spring", "~> 2.0"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console", "~> 3.5"
end
