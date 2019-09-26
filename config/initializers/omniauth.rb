# config/initializers/omniauth.rb
module OmniAuth
  module Strategies
    # tell OmniAuth to load our strategy
    autoload :Spidauth, 'lib/omniauth/strategies/spidauth'
  end
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :spidauth 
end