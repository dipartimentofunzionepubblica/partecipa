# frozen_string_literal: true

Rake::Task["decidim:content_blocks:initialize_default_content_blocks"].clear

namespace :decidim do
  namespace :content_blocks do
    desc "Initializes content blocks using native ActiveRecord for Decidim 0.28"
    task :initialize_default_content_blocks, [:space_id, :override, :custom_blocks, :include_components] => :environment do |_task, args|
      
      space_id = args[:space_id]&.to_i
      override_existing = args[:override].nil? ? true : args[:override] != "false"
      include_components = args[:include_components] == "true"

      # Usiamo i manifest corretti emersi dal debug in console
      DEFAULT_BLOCKS = ["hero", "main_data", "extra_data", "related_documents"].freeze
      
      allowed_blocks = if args[:custom_blocks].present?
                         args[:custom_blocks].split(";").map(&:strip)
                       else
                         DEFAULT_BLOCKS
                       end
      
      TARGET_SCOPE = "participatory_process_homepage"

      puts "=== INIZIO RIGENERAZIONE CONTENT BLOCKS (ActiveRecord Mode) ==="
      puts "Blocchi target: #{allowed_blocks.join(', ')}"

      processes = if space_id.present?
                    Decidim::ParticipatoryProcess.where(id: space_id)
                  else
                    Decidim::ParticipatoryProcess.all
                  end

      if processes.empty?
        puts "Nessun processo trovato."
        next
      end

      processes.each do |process|
        puts "Elaborazione Processo ID: #{process.id} - #{process.slug}"

        existing_blocks = Decidim::ContentBlock.where(
          scope_name: TARGET_SCOPE,
          scoped_resource_id: process.id
        )

        if existing_blocks.any? && !override_existing
          puts "   -> [SALTATO] Il processo ha già blocchi esistenti della homepage."
          next
        end

        # Distruzione tramite ORM (invoca correttamente i callback di pulizia ed evita disallineamenti)
        if existing_blocks.any?
          existing_blocks.destroy_all
        end

        # Inserimento controllato tramite il modello Rails
        allowed_blocks.each_with_index do |block_name, index|
          weight = (index + 1) * 10
          
          begin
            # create! costringe Rails e Decidim a pre-popolare i settings del manifest
            Decidim::ContentBlock.create!(
              decidim_organization_id: process.decidim_organization_id,
              scope_name: TARGET_SCOPE,
              scoped_resource_id: process.id,
              manifest_name: block_name,
              weight: weight,
              published_at: Time.current,
              settings: {}, 
              images: {}
            )
          rescue => e
            puts "   -> [ERRORE] Errore durante la creazione del blocco #{block_name}: #{e.message}"
          end
        end

        if include_components
          begin
            content_blocks_creator = Decidim::ContentBlocksCreator.new(process)
            content_blocks_creator.create_components_blocks!
          rescue => e
            puts "   -> [AVVISO] Impossibile creare i blocchi dei componenti: #{e.message}"
          end
        end

        # Verifica finale post-salvataggio
        creati = Decidim::ContentBlock.where(scoped_resource_id: process.id, scope_name: TARGET_SCOPE).order(:weight).map(&:manifest_name)
        puts "   -> Blocchi registrati in sicurezza: #{creati.join(', ')}"
      end

      puts "=== FINE PROCESSO ==="
    end
  end
end