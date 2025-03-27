# config/initializers/lograge.rb
# OR
# config/environments/production.rb
Rails.application.configure do
  config.lograge.enabled = true
  
  # add time to lograge
  config.lograge.custom_options = lambda do |event|
    { time: Time.now }
  end
end