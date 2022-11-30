# frozen_string_literal: true

source 'https://rubygems.org'

ruby RUBY_VERSION
DECIDIM_VERSION = 'release/0.25-stable'

gem 'bootsnap', '~> 1.4'
gem 'daemons'
gem 'decidim', git: 'https://github.com/decidim/decidim', tag: DECIDIM_VERSION
gem 'decidim-decidim_awesome'
gem 'decidim-templates', git: 'https://github.com/decidim/decidim', tag: DECIDIM_VERSION
gem 'decidim-term_customizer', branch: DECIDIM_VERSION, git: 'https://github.com/mainio/decidim-module-term_customizer'
gem 'delayed_job_active_record'
gem 'faker', '~> 2.14'
gem 'foundation_rails_helper', git: 'https://github.com/sgruhier/foundation_rails_helper.git'
gem 'figaro'
gem 'pg'
gem 'puma'
gem 'rake'
gem 'uglifier', '~> 4.1'
gem 'decidim-spid-cie', git: 'https://github.com/kapusons/decidim-module-spid-cie', ref: 'a41922457d4c7d9eea7cf08539b95bc33c29cefe'
gem 'decidim-privacy', git: 'https://github.com/kapusons/decidim-module-privacy', ref: '399ee9c4f32ccd177f3aa7993dc865ee500da09b'
gem 'decidim-analytics', git: 'https://github.com/digidemlab/decidim-module-analytics'
gem 'deface'

group :development, :test do
  gem 'byebug', '~> 11.0', platform: :mri

  # Use latest simplecov from master until next version of simplecov is
  # released (greather than 0.18.5)
  # See https://github.com/decidim/decidim/issues/6230
  gem 'simplecov', '~> 0.19.0'
  gem 'decidim-dev', git: 'https://github.com/decidim/decidim', tag: DECIDIM_VERSION
end

group :development do
  gem 'letter_opener_web', '~> 1.3'
  gem 'listen', '~> 3.1'
  gem 'rubocop-faker'
  gem 'spring', '~> 2.0'
  gem 'spring-watcher-listen', '~> 2.0'
  gem 'web-console', '4.0.4'
  gem 'xray-rails'
end
