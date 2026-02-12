# frozen_string_literal: true

source "http://rubygems.org"

ruby RUBY_VERSION

gem "decidim", "0.28.6"

gem "bootsnap", "~> 1.3"
gem "puma", ">= 6.3.1"
gem "wicked_pdf", "~> 2.1"
gem "pg"
gem "figaro"
gem "daemons"
gem "delayed_job_active_record"
gem 'foundation_rails_helper', git: 'https://github.com/sgruhier/foundation_rails_helper.git'

gem 'decidim-term_customizer', git: 'https://github.com/mainio/decidim-module-term_customizer', branch: 'release/0.28-stable'
gem 'decidim-privacy', branch: 'release/0.28' , git: 'https://github.com/dipartimentofunzionepubblica/decidim-module-privacy'
gem 'decidim-cache_cleaner'
gem 'decidim-decidim_awesome'

gem 'sprockets-rails'

gem 'lograge'


group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri

  gem "brakeman", "~> 5.4"
  gem "decidim-dev", "0.28.6"
  gem "net-imap", "~> 0.2.3"
  gem "net-pop", "~> 0.1.1"
  gem "net-smtp", "~> 0.3.1"
end

group :development do
  gem "letter_opener_web", "~> 2.0"
  gem "listen", "~> 3.1"
  gem "web-console", "~> 4.2"
  gem 'xray-rails'
end

group :production do
end
