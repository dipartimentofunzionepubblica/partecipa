# frozen_string_literal: true

source 'https://rubygems.org'

ruby RUBY_VERSION
DECIDIM_VERSION = 'v0.26.10'

gem 'bootsnap', '~> 1.4'
gem 'daemons'
gem 'decidim', git: 'https://github.com/decidim/decidim', tag: DECIDIM_VERSION
gem 'decidim-decidim_awesome'
gem 'decidim-privacy', git: 'https://github.com/dipartimentofunzionepubblica/decidim-module-privacy', branch: 'bump_to_0.26'
gem 'decidim-pua', git: 'https://github.com/dipartimentofunzionepubblica/decidim-module-pua', branch: 'bump_to_0.26'
gem 'decidim-templates', git: 'https://github.com/decidim/decidim', tag: DECIDIM_VERSION
gem 'decidim-term_customizer', branch: 'release/0.26-stable', git: 'https://github.com/mainio/decidim-module-term_customizer'
gem 'decidim-survey_results', git: 'https://github.com/CodiTramuntana/decidim-module-survey_results', branch: 'release/0.26-stable'
gem 'deface'
gem 'delayed_job_active_record'
gem 'figaro'
gem 'foundation_rails_helper', git: 'https://github.com/sgruhier/foundation_rails_helper.git'
gem 'pg'
gem 'puma'
gem 'rake'
gem 'uglifier', '~> 4.1'
gem 'mini_portile2', '~> 2.8.2'
gem 'wicked_pdf', '~> 2.1'
gem 'wkhtmltopdf-binary'

group :development, :test do
  gem 'byebug', '~> 11.0', platform: :mri

  # Use latest simplecov from master until next version of simplecov is
  # released (greather than 0.18.5)
  # See https://github.com/decidim/decidim/issues/6230
  gem 'decidim-dev', git: 'https://github.com/decidim/decidim', tag: DECIDIM_VERSION
  gem 'simplecov', '~> 0.19.0'
end

group :development do
  gem 'letter_opener_web', '~> 1.3'
  gem 'listen', '~> 3.1'
  gem 'rubocop-faker'
  gem 'spring', '~> 4.0'
  gem 'spring-watcher-listen', '~> 2.1'
  gem 'web-console', '4.0.4'
  gem 'xray-rails'
  gem 'faker', :require => false
end
