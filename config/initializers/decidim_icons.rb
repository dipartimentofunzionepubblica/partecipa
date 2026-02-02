Rails.application.config.to_prepare do
  Decidim.icons.register(
    name: "spid-fill", 
    icon: "spid-fill", 
    category: "system", 
    description: "Icona per login SPID", 
    engine: :core
  )
  Decidim.icons.register(
    name: "book", 
    icon: "book", 
    category: "system", 
    description: "", 
    engine: :core
  )
  Decidim.icons.register(
    name: "data-transfer-download", 
    icon: "data-transfer-download", 
    category: "system", 
    description: "", 
  engine: :core)
end