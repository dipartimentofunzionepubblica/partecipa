# frozen_string_literal: true

source 'https://rubygems.org'

ruby RUBY_VERSION

gem 'bootsnap', '~> 1.3'
gem 'daemons'
gem 'decidim', '0.20.0'
gem 'decidim-conferences', '0.20.0'
gem 'decidim-term_customizer', branch: '0.20-stable', git: 'https://github.com/mainio/decidim-module-term_customizer'
gem 'delayed_job_active_record'
gem 'faker', '~> 1.9'
gem 'figaro'
gem 'omniauth'
gem 'omniauth-rails_csrf_protection'
gem 'passenger'
gem 'pg'
gem 'puma', '~> 3.0'
gem 'spid-rails', '= 0.2.0'
gem 'uglifier', '~> 4.1'

group :development, :test do
  gem 'byebug', '~> 11.0', platform: :mri
  gem 'decidim-dev', '0.20.0'
end

group :development do
  gem 'letter_opener_web', '~> 1.3'
  gem 'listen', '~> 3.1'
  gem 'rubocop'
  gem 'spring', '~> 2.0'
  gem 'spring-watcher-listen', '~> 2.0'
  gem 'web-console', '~> 3.5'
  gem 'xray-rails'
end
