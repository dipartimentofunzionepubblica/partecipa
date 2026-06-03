# lib/tasks/decidim_delayed_job_watchdog.rake
namespace :delayed_job do
  desc "Controlla se delayed_job è attivo e lo riavvia se è down"
  task :check_and_restart => :environment do
    pid_file = Rails.root.join('tmp', 'pids', 'delayed_job.pid')
    script_path = Rails.root.join('bin', 'delayed_job')
    
    process_running = false
    pid = nil

    # 1. Controlla se il file PID esiste
    if File.exist?(pid_file)
      pid = File.read(pid_file).strip.to_i
      if pid > 0
        # Controlla se il processo associato al PID esiste davvero
        begin
          Process.getpgid(pid)
          process_running = true
          puts "[#{Time.current}] delayed_job è attivo (PID: #{pid})."
        rescue Errno::ESRCH
          puts "[#{Time.current}] File PID trovato, ma il processo #{pid} è morto. Pulisco..."
          File.delete(pid_file)
        end
      end
    end

    # 2. Controllo di sicurezza secondario (Antifantasma)
    unless process_running
      current_pid = Process.pid
      
      # Usiamo ps per elencare solo i processi dell'utente corrente, 
      # estraendo PID e riga di comando direttamente, evitando pgrep.
      matching_pids = []
      
      # Questo comando elenca PID e comando di tutti i processi dell'utente corrente
      `ps -u #{ENV['USER']} -o pid=,args=`.split("\n").each do |line|
        parts = line.strip.split(/\s+/, 2)
        next if parts.length < 2
        
        p = parts[0].to_i
        cmd_line = parts[1]
        
        # Escludiamo il task Rake corrente, i processi zombie e i comandi di controllo
        if cmd_line.include?("delayed_job") && 
           p != current_pid && 
           !cmd_line.include?("rake") && 
           !cmd_line.include?("ps -u")
           
          matching_pids << p
          puts "[#{Time.current}] Trovato processo sospetto ma valido (PID: #{p}): #{cmd_line}"
        end
      end

      if matching_pids.any?
        puts "[#{Time.current}] Il file PID manca, ma ci sono processi reali attivi. Non riavvio per sicurezza."
        process_running = true
      end
    end

    # 3. Se è effettivamente down, lo avviamo
    unless process_running
      puts "[#{Time.current}] delayed_job risulta DOWN. Tentativo di avvio..."
      
      # Eseguiamo il bin/delayed_job in background
	  system("RAILS_ENV=#{Rails.env} DISABLE_SPRING=1 bundle exec #{script_path} start")
      
      if $?.success?
        puts "[#{Time.current}] Comando di avvio impartito con successo."
      else
        puts "[#{Time.current}] Errore durante l'esecuzione del comando di avvio."
      end
    end
  end
end
