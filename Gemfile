# frozen_string_literal: true

source 'http://rubygems.org'

ruby RUBY_VERSION
DECIDIM_VERSION = 'release/0.28-stable'

gem 'decidim', git: 'https://github.com/decidim/decidim', tag: DECIDIM_VERSION
gem 'decidim-decidim_awesome'
#, git: 'https://github.com/decidim-ice/decidim-module-decidim_awesome', branch: 'release/0.28-stable'
gem 'decidim-privacy', branch: 'release/0.28' , git: 'https://github.com/dipartimentofunzionepubblica/decidim-module-privacy'
gem 'decidim-pua', git: 'https://github.com/dipartimentofunzionepubblica/decidim-module-pua', branch: 'bump_to_0.28'
gem 'decidim-term_customizer', git: 'https://github.com/mainio/decidim-module-term_customizer', branch: 'release/0.28-stable'
gem 'decidim-cache_cleaner'
gem 'bootsnap', '~> 1.3'
gem 'puma', '>= 6.3.1'
gem 'wicked_pdf', '~> 2.1'
gem 'pg'
gem 'figaro'
gem 'lograge'
gem 'daemons'
gem 'delayed_job_active_record'
gem 'foundation_rails_helper', git: 'https://github.com/sgruhier/foundation_rails_helper.git'
gem 'sprockets-rails'
gem 'deface'

group :development, :test do
  gem 'byebug', '~> 11.0', platform: :mri

  gem 'brakeman', '~> 5.4'
  gem 'decidim-dev', git: 'https://github.com/decidim/decidim', tag: DECIDIM_VERSION
  gem 'net-imap', '~> 0.2.3'
  gem 'net-pop', '~> 0.1.1'
  gem 'net-smtp', '~> 0.3.1'
end

group :development do
  gem 'letter_opener_web', '~> 2.0'
  gem 'listen', '~> 3.1'
  gem 'web-console', '~> 4.2'
  gem 'xray-rails'
end
