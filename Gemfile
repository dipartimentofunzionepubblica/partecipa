# frozen_string_literal: true

source 'http://rubygems.org'

ruby RUBY_VERSION
DECIDIM_VERSION = 'v0.27.9'

gem 'bootsnap', '~> 1.4'
gem 'daemons'
gem 'decidim', git: 'http://github.com/decidim/decidim', tag: DECIDIM_VERSION
gem 'decidim-decidim_awesome'
#gem 'decidim-privacy', git: 'https://github.com/dipartimentofunzionepubblica/decidim-module-privacy', branch: 'bump_to_0.26'
gem 'decidim-privacy', git: 'https://github.com/mainio/decidim-module-privacy', branch: 'release/0.27-stable'
gem 'decidim-pua', git: 'https://github.com/dipartimentofunzionepubblica/decidim-module-pua', branch: 'bump_to_0.27'
gem 'decidim-templates', git: 'https://github.com/decidim/decidim', tag: DECIDIM_VERSION
gem 'decidim-term_customizer', branch: 'release/0.27-stable', git: 'https://github.com/mainio/decidim-module-term_customizer'
#gem 'decidim-survey_results', git: 'https://github.com/CodiTramuntana/decidim-module-survey_results', branch: 'main'
gem 'deface'
gem 'delayed_job_active_record'
gem 'figaro'
gem 'foundation_rails_helper', git: 'http://github.com/sgruhier/foundation_rails_helper.git'
gem 'pg'
gem 'puma'
gem 'rake'
gem 'uglifier', '~> 4.1'
gem 'mini_portile2', '~> 2.8.2'
gem 'wicked_pdf', '~> 2.1'
gem 'wkhtmltopdf-binary'
gem 'concurrent-ruby', '1.3.4'

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
