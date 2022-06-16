# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION
DECIDIM_VERSION = "release/0.24-stable"

gem "rails", "= 5.2.6"
gem "decidim", git: 'https://github.com/decidim/decidim', tag: DECIDIM_VERSION
gem "bootsnap", "~> 1.4"
gem "puma"
gem "uglifier", "~> 4.1"
gem "faker", "~> 1.9"
gem "figaro"
gem "omniauth", '>= 1.9.0'
gem "omniauth-rails_csrf_protection"
gem "rake"
gem "pg"
gem "spid-rails", "= 0.2.0"
gem "decidim-comparative_stats", "~> 1.1.0"
# nokogiri locked at 1.13.4 https://github.com/decidim/decidim/issues/9295
gem "nokogiri", "1.13.4"
gem "decidim-term_customizer", branch: '0.24-stable', git: 'https://github.com/mainio/decidim-module-term_customizer'
gem "decidim-decidim_awesome"

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri
  # Use latest simplecov from master until next version of simplecov is
  # released (greather than 0.18.5)
  # See https://github.com/decidim/decidim/issues/6230
  gem "simplecov", "~> 0.19.0"
  gem "decidim-dev", git: 'https://github.com/decidim/decidim', tag: DECIDIM_VERSION
end

group :development do
  gem 'letter_opener_web', '~> 1.3'
  gem 'listen', '~> 3.1'
  gem 'rubocop'
  gem 'rubocop-rails'
  gem 'spring', '~> 2.0'
  gem 'spring-watcher-listen', '~> 2.0'
  gem 'web-console', '~> 3.5'
  gem 'xray-rails'
end
