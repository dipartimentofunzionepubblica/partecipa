# frozen_string_literal: true

source 'http://rubygems.org'

ruby RUBY_VERSION
DECIDIM_VERSION = 'v0.27.10'

gem 'bootsnap', '~> 1.4'
gem 'daemons'
gem 'decidim', git: 'http://github.com/decidim/decidim', tag: DECIDIM_VERSION
gem 'decidim-decidim_awesome', '0.10.2'
gem 'decidim-privacy', git: 'https://github.com/dipartimentofunzionepubblica/decidim-module-privacy', branch: 'bump_to_0.27'
gem 'decidim-pua', git: 'https://github.com/dipartimentofunzionepubblica/decidim-module-pua', branch: 'bump_to_0.27'
gem 'decidim-templates', git: 'https://github.com/decidim/decidim', tag: DECIDIM_VERSION
gem 'decidim-term_customizer', branch: 'release/0.27-stable', git: 'https://github.com/mainio/decidim-module-term_customizer'
gem 'decidim-survey_results', git: 'https://github.com/maintainer-partecipa/decidim-module-survey_results', branch: 'bump_to_0.27'
gem 'decidim-cache_cleaner'
gem 'deface'
gem 'delayed_job_active_record'
gem 'figaro'
gem 'foundation_rails_helper', git: 'http://github.com/sgruhier/foundation_rails_helper.git'
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
  gem 'decidim-dev', git: 'http://github.com/decidim/decidim', tag: DECIDIM_VERSION
  gem 'simplecov', '~> 0.21.0'
  gem "brakeman", "~> 5.2"
  gem "parallel_tests", "~> 3.7"
end

group :development do
  gem 'letter_opener_web', '~> 2.0'
  gem 'listen', '~> 3.1'
  gem 'rubocop-faker'
  gem 'spring', '~> 4.0'
  gem 'spring-watcher-listen', '~> 2.1'
  gem 'web-console', '4.2'
  gem 'xray-rails'
  gem 'faker', :require => false
end
