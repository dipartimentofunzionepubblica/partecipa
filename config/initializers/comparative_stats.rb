# frozen_string_literal: true

Decidim::ComparativeStats.configure do |config|
  config.stats_cache_expiration_time = 2.hour
end
