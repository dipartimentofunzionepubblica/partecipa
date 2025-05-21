# config/initializers/lograge.rb
# OR
# config/environments/production.rb
Rails.application.configure do
  config.lograge.enabled = true
  
  config.lograge.custom_payload do |controller|
    {
      user_id: controller.current_user.try(:id),
      ip: controller.request.try(:ip)
    }
  end
  
  config.lograge.ignore_actions = [
    "ActiveStorage::DiskController#show",
    "ActiveStorage::RepresentationsController#show",
    "ActiveStorage::Representations::RedirectController#show"
  ]
end