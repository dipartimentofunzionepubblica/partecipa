if Rails.env.production?
  OmniAuth.config.logger = Rails.logger

  # Logga ogni volta che una strategia viene inizializzata o chiamata
  OmniAuth.config.before_request_phase = proc do |env|
    strategy = env['omniauth.strategy']
    if strategy && strategy.options[:name].include?("openid_connect")
      Rails.logger.debug "==============> STRATEGY DETECTED: #{strategy.class}"
      Rails.logger.debug "==============> PATH: #{env['PATH_INFO']}"
      # Questo ti dirà se la strategia conosce gli endpoint del tenant
      Rails.logger.debug "==============> CLIENT_OPTIONS: #{strategy.options[:client_options].inspect}"
    end
  end
end