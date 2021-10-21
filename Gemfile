# frozen_string_literal: true

source 'https://rubygems.org'

ruby RUBY_VERSION
gem 'rails', '5.2.4.5'

gem 'bootsnap', '~> 1.4'
gem 'daemons'
gem 'decidim', '0.22.0'
gem 'decidim-term_customizer', branch: '0.22-stable', git: 'https://github.com/mainio/decidim-module-term_customizer'
gem 'delayed_job_active_record'
gem 'faker', '~> 1.9'
gem 'figaro'
gem 'omniauth', '>= 1.9.0'
gem 'omniauth-rails_csrf_protection'
gem 'passenger'
gem 'pg'
gem 'puma', '>= 4.3.3'
gem 'spid-rails', '= 0.2.0'
gem 'uglifier', '~> 4.1'

group :development, :test do
  gem 'byebug', '~> 11.0', platform: :mri
  gem 'decidim-dev', '0.22.0'
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
