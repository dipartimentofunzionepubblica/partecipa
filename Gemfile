# frozen_string_literal: true

source 'https://rubygems.org'

ruby RUBY_VERSION
DECIDIM_VERSION = '0.28.6'

gem 'bootsnap'
gem 'daemons'
gem 'decidim', DECIDIM_VERSION
gem 'decidim-decidim_awesome'
gem 'decidim-privacy', git: 'https://github.com/dipartimentofunzionepubblica/decidim-module-privacy', branch: 'release/0.28'
gem 'decidim-pua', git: 'https://github.com/dipartimentofunzionepubblica/decidim-module-pua', branch: 'bump_to_0.28'
gem 'decidim-templates', DECIDIM_VERSION
gem 'decidim-term_customizer', branch: 'release/0.28-stable', git: 'https://github.com/mainio/decidim-module-term_customizer'
gem 'decidim-cache_cleaner'
gem 'deface'
gem 'delayed_job_active_record'
gem 'figaro'
gem 'foundation_rails_helper', git: 'https://github.com/sgruhier/foundation_rails_helper.git'
gem 'lograge'
gem 'pg'
gem 'puma'
gem 'rake'
gem 'uglifier'
gem 'mini_portile2'
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'
gem 'concurrent-ruby'

group :development, :test do
  gem 'byebug', '~> 11.0', platform: :mri

  # Use latest simplecov from master until next version of simplecov is
  # released (greather than 0.18.5)
  # See https://github.com/decidim/decidim/issues/6230
  gem 'decidim-dev', '0.28.6'
  gem 'simplecov'
  gem "brakeman"
  gem "parallel_tests"
end

group :development do
  gem 'letter_opener_web'
  gem 'listen'
  gem 'rubocop-faker'
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'web-console'
  gem 'xray-rails'
  gem 'faker', '< 3.6.0'
end
