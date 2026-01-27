Rails.application.config.to_prepare do
  Decidim.icons.register(
    name: "spid-fill", 
    icon: "spid-fill", 
    category: "system", 
    description: "Icona per login SPID", 
    engine: :core
  )
end