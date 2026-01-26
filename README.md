# ParteciPa

## Piattaforma di partecipazione democratica

ParteciPa è la piattaforma di consultazione e partecipazione online promossa dal Dipartimento della Funzione Pubblica e dal Dipartimento per le Riforme istituzionali della Presidenza del Consiglio dei Ministri.
Una descrizione dell’applicazione e delle sue funzionalità è disponibile alla pagina
[Scopri ParteciPa](http://www.funzionepubblica.gov.it/articolo/ministro/05-12-2019/governo-al-portale-e-piattaforma-%E2%80%9Cpartecipa%E2%80%9D-consultazioni-pubbliche) .

## Software

ParteciPa è un progetto Open-Source basato su [Decidim](https://github.com/decidim/decidim), la piattaforma di partecipazione democratica creata dalla città di Barcellona e utilizzata da numerose amministrazioni in tutto il mondo.
Decidim è concesso in licenza attraverso la [GNU Affero General Public License v3.0](https://github.com/decidim/decidim/blob/develop/LICENSE-AGPLv3.txt).
Prima di installare e utilizzare ParteciPa raccomandiamo un attento esame della documentazione relativa a Decidim e di questo README.

Dal punto di vista tecnico Decidim è basato su:
* Framework: Ruby on Rails;
* Linguaggio: Ruby;
* Database: Postgres;
* Application Server: Passenger/Nginx.

I manuali di Amministrazione per Decidim si trovano nei seguenti URL:

https://decidim.org/docs/
https://docs.decidim.org/
	
Istruzioni dettagliate su come installare Decidim si trovano a [questo indirizzo](https://platoniq.github.io/decidim-install/).

Le seguenti istruzioni di installazione riguardano la sola installazione o aggiornamento di ParteciPa:

scaricare da GitHub.com

	git clone https://github.com/dipartimentofunzionepubblica/partecipa.git

installare le dipendenze

	bundle install

precompilare gli assets

	bundle exec rails assets:precompile

aggiornare il db

	bundle exec rails db:migrate

vedere sotto i file di configurazione da compilare adeguatamente

## Moduli

Decidim è articolato in più moduli che possono essere inclusi nell'applicativo opzionalmente.

Per includere un nuovo modulo occorre aggiungerlo al Gemfile

ad es., nel caso del modulo conferenze, versione 0.20.0

	gem "decidim-conferences", "0.20.0"

per installare il nuovo modulo sarà poi necessario eseguire

	bundle install

e installare ed eseguire le migrations relative al modulo appena installato

	bundle exec rails decidim_conferences:install:migrations
	bundle exec rails db:migrate


## Modifiche e integrazioni di ParteciPa rispetto a Decidim

ParteciPa usa il core di Decidim e personalizza o integra solo i seguenti aspetti:

* Utilizzo del Sistema Pubblico di Identità Digitale (Spid), della Carta di Identità Elettronica (CIE) e della Carta Nazionale dei Servizi (CNS) attraverso il Punto Unico d'Accesso (PUA) ;
* Aspetto grafico ridefinito via SCSS;
* Modifiche sul profilo dell’utente per soddisfare le indicazioni del GDPR;
* Integrazione dei moduli community;
* Installazione in modalità multi-tenant.
 
## Utilizzo del Sistema Pubblico di Identità Digitale (Spid), della Carta di Identità Elettronica (CIE) e della Carta Nazionale dei Servizi (CNS) attraverso il Punto Unico d'Accesso (PUA)

L'attivazione di partecipa.gov.it come Service Provider Spid, CIE e CNS ha necessitato della applicazione della procedura di accreditamento tramite PUA (Punto Unico di Accesso) del DFP (Dipartimento Funzione Pubblica).
L'accreditamento PUA avviene a seguito di verifica dei requisiti da parte di DFP ed esclusivamente per siti afferenti al Dipartimento stesso.

Per integrare PUA ParteciPa utilizza il middleware Open-Source [Decidim-pua](https://github.com/dipartimentofunzionepubblica/decidim-module-pua) . In alternativa, in caso di impossibilità di accredito su PUA, è possibile gestire la login in single sign-on SPID e CIE attraverso la gem [Decidim-spid-cie](https://github.com/dipartimentofunzionepubblica/decidim-module-spid-cie) .

ParteciPa richiede per suo utilizzo tre soli attributi utente: l'Indirizzo di posta elettronica, il Codice identificativo Spid (ove applicabili) e il Codice Fiscale.
La piattaforma non memorizza in alcun modo le credenziali Spid, CIE o CNS dell'utente; vengono tracciati in un apposito log contenuto nel Database gli eventi di registrazione, login e logout dell'Utente.
ParteciPa utilizza tutte le raccomandazioni prescritte da Spid, CIE o CNS per garantire la massima sicurezza nelle transazioni.

Per abilitare il login PUA alla piattafoma ParteciPa, la piattaforma deve essere configurata adeguatamente. 
E' indispensabile che sia configurato il file <partecipa_path>/config/application.yml che contiene le informazioni essenziali per il sistema, si veda sotto per maggiori dettagli.

Il file secrets.yml funge da collettore di tutte le costanti importandole da application.yml e non deve essere editato.
Si rimanda al README.md della gem [Decidim-pua](https://github.com/dipartimentofunzionepubblica/decidim-module-pua) per i dettagli relativi alla configurazione del sistema con PUA e quindi per l'autenticazione con SPID, CIE e CNS.

## Aspetto grafico ridefinito via SCSS

L'aspetto grafico di ParteciPa è stato ridefinito rispettando quanto previsto dalle [Linee Guida per il design dei siti PA](https://www.agid.gov.it/it/argomenti/linee-guida-design-pa).

## Modifiche sul profilo dell’utente per soddisfare le indicazioni del GDPR

Per meglio salvaguardare la privacy dei partecipanti ai processi di consultazione sono stati realizzati degli interventi che consentono a ParteciPa di soddisfare al meglio le indicazioni italiane per l’applicazione del GDPR:
* Rimozione della possibilità per l’utente di caricare avatar personalizzato;
* Eliminazione della visibilità pubblica del profilo Utente;
* Rimozione della funzionalità che permette  di "seguire" un Utente;
* Rimozione della funzionalità di ricerca di un Utente e dei Commenti;
* Rimozione della possibilità di contattare gli Utenti;
* Rimozione della ricercabilità su Google del profilo Utente.

## Integrazione dei moduli community

Decidim utilizza un sistema centralizzato di definizione della localizzazione della piattaforma attraverso [Crowdin](https://crowdin.com/) nel quale le traduzioni sono applicabili indistintamente a tutte le istanze della piattaforma nella lingua data.
Il modulo community [Term-Customizer](https://github.com/mainio/decidim-module-term_customizer) può essere utilizzato per creare traduzioni applicabili alla sola istanza della piattaforma che si sta utilizzando.
Il modulo community [Decidim-Awesome](https://github.com/Platoniq/decidim-module-decidim_awesome) fornisce un set di funzionalità avanzate che riguardano vari aspetti delle consultazioni.
Il modulo community [Decidim-Privacy](https://github.com/dipartimentofunzionepubblica/decidim-module-privacy) fornisce la possibilità di applicare una serie di restrizioni opzionali che hanno lo scopo di salvaguardare maggiormente la privacy dei partecipanti. 

## Installazione in modalità multi-tenant

Una stessa istanza di Decidim può essere utilizzata per più Organizzazioni in modalità multi-tenant. Le diverse Organizzazioni afferenti alla stessa istanza condividono aspetto grafico e localizzazione ma sono completamente slegate dal punto di vista delle informazioni immesse al loro interno e per quanto riguarda gli utenti registrati. Ciascuna Organizzazione risponde ad un diverso indirizzo.

## application.yml

Il file <partecipa_path>/config/application.yml contiene le principali configurazioni indispensabili per il funzionamento dell'applicativo.
La creazione e la redazione del file è a cura di chi installa la piattaforma secondo le indicazioni sotto, il file non è compreso nel repository.
Di seguito una breve spiegazione per ciascuna costante:

	SECRET_KEY_BASE: #Secret key utilizzata da Rails per il suo funzionamento vedere https://medium.com/@michaeljcoyne/understanding-the-secret-key-base-in-ruby-on-rails-ce2f6f9968a1
	HOST: #Nome dell'host
	PROTOCOL: #https
	GOOGLE_ANALYTICS_ID: #Google Analytics ID di monitoraggio vedere https://support.google.com/analytics/answer/7372977
	MATOMO_URL: #URL istanza Matomo
	MATOMO_ID: #ID Matomo
	
	DATABASE_URL: #URL del DB nella seguente forma "postgres://<DATABASE_USERNAME>:<DATABASE_PASSWORD>@<DATABASE_HOST>/<DATABASE_NAME>"
	DATABASE_HOST: #Host che ospita il DB
	DATABASE_USERNAME: #Username del DB
	DATABASE_PASSWORD: #Password del DB

	SMTP_USERNAME: #Username dell'account di posta utilizzato per la spedizione delle mail della piattaforma via SMTP
	SMTP_PASSWORD: #Password dell'account di posta
	SMTP_ADDRESS: #Indirizzo dell'SMTP
	SMTP_DOMAIN: #Dominio dell'SMTP

	GEOCODER_API_KEY: #here_api_key relativo al Geocoder Here vedere https://github.com/decidim/decidim/blob/0.21-stable/docs/services/geocoding.md
	
	PUA_TENANT_NAME: #Stringa che identifica il nome del tenant PUA, in caso non sia presente l'initializer PUA non parte evitando un errore in mancanza di configurazione PUA
	PUA_BUTTON_SIZE: #Stringa ["s","m","l","xl"] che determina la dimensione del bottone Accedi per PUA
	PUA_ISSUER: #Stringa indicante l'URL relativo al servizio PUA, normalmente in produzione "https://sso.dfp.gov.it"
	PUA_RELYING_PARTY: #Stringa indicante il servizio del Service Provider corrente, nel nostro caso "https://partecipa.gov.it"
	PUA_APP_ID: #Stringa indicante l'app_id univoco che identifica il Service Provider, comunicato da DFP in fase di accreditamento
	PUA_APP_SECRET: #Stringa indicante il secret che serve all'autenticazione del Service Provider, comunicato da DFP in fase di accreditamento

	COMPONENT_TABS: #Intero indicante il numero massimo di tabs Componenti che appaiono a fianco al nome Processo/Assemblea
	
	DECIDIM_APPLICATION_NAME: #Stringa che identifica il nome dell'applicativo
	DECIDIM_MAILER_SENDER: #Stringa che indica l'indirizzo email mittente delle comunicazioni e notifiche
	DECIDIM_AVAILABLE_LOCALES: #Stringa che inentifica i locales attivati nell'instanza corrente, ad es. "en, it"
	DECIDIM_DEFAULT_LOCALE: #Stringa che identifica il locale di default ad es. "it"
	DECIDIM_FORCE_SSL: #Stringa che segnala se il protocollo SSL deve essere forzato, ad es. "auto" o "true" o "false"
	DECIDIM_ENABLE_HTML_HEADER_SNIPPETS: #Booleano che determina se saranno presenti gli header snippets, ad es. per inserire javascript nell header da configurare in dashboard
	DECIDIM_CURRENCY_UNIT: #Stringa che determina quale è la divisa monetaria di default, ad es. "€"
	DECIDIM_CORS_ENABLED: #Booleano che determina se CORS (Cross-Origin Resource Sharing) è attivato, nel caso lo sia è possibile  richiedere risorse (come font, JavaScript, immagini) da un dominio diverso da quello da cui la pagina web è stata caricata
	DECIDIM_IMAGE_UPLOADER_QUALITY: #Intero che determina la qualità delle immagini caricate tramite uploader, ad es. "80"
	DECIDIM_MAXIMUM_ATTACHMENT_SIZE: #Intero che determina la dimensione massima in Megabytes delle immagini caricate
	DECIDIM_MAXIMUM_AVATAR_SIZE: "5" #Intero che determina la dimensione massima in Megabytes degli avatar caricati
	DECIDIM_MAX_REPORTS_BEFORE_HIDING: #Intero che determina di report che un contenuto può ricevere prima di essere nascosto
	DECIDIM_TRACK_NEWSLETTER_LINKS: #Stringa con cui viene configurato il tracciamento dei link della newsletter tramite UTM
	DECIDIM_DOWNLOAD_YOUR_DATA_EXPIRY_TIME: #Intero che configura il numero di giorni in cui il download dei dati sarà disponibile sul server, una volta richiesto
	DECIDIM_THROTTLING_MAX_REQUESTS: #Intero che identifica il numero massimo di richieste nell'unità di tempo per IP prima che vengano bloccate
	DECIDIM_THROTTLING_PERIOD: #Intero che identifica l'unità di tempo in minuti che si riferisce al conteggio sopra
	DECIDIM_UNCONFIRMED_ACCESS_FOR: #Intero che si riferisce al numero massimo di giorni in cui il sito è accessibile senza che l'email sia confermata
	DECIDIM_SYSTEM_ACCESSLIST_IPS: #Stringa che è un elenco di IP o subnet separati da virgola che descrive chi può accedere alla parte /system del sito
	DECIDIM_BASE_UPLOADS_PATH: #Stringa che definisce un base path per gli uploads
	DECIDIM_DEFAULT_CSV_COL_SEP: #Stringa che definisce il separatore tra campi nel file csv
	DECIDIM_CONSENT_COOKIE_NAME: #Stringa che definisce il nome del cookie con cui viene memorizzato sul browser il consenso relativo al trattamento dati
	DECIDIM_CACHE_KEY_SEPARATOR: #Stringa che definisce il separatore della chiave della cache
	DECIDIM_EXPIRE_SESSION_AFTER: #Intero che definisce dopo quanti minuti far scadere la sessione
	DECIDIM_SESSION_TIMEOUT_INTERVAL: #Intero che definisce dopo quanti minuti chiedere conferma della presenza utente
	DECIDIM_ENABLE_REMEMBER_ME: #Stringa che abilita il checkbox "Ricordati di me", ad es. "auto"
	DECIDIM_FOLLOW_HTTP_X_FORWARDED_HOST: #Stringa che espone una opzione di configurazione: HTTP_X_FORWARDED_HOST
	DECIDIM_MAXIMUM_CONVERSATION_MESSAGE_LENGTH: #Intero che definisce il numero massimo di caratteri per messaggio
	DECIDIM_PASSWORD_BLACKLIST: #Stringa che definisce una lista di parole non consentite nelle password
	DECIDIM_ALLOW_OPEN_REDIRECTS: #Booleano che disabilita il redirect ad un altro host quando si esegue il redirect di ritorno
	DECIDIM_SERVICE_WORKER_ENABLED: #Booleano che abilita o disabilita il service worker che serve a ad abilitare il supporto offline e le notifiche push
	DECIDIM_ADMIN_PASSWORD_EXPIRATION_DAYS: #Intero che indica i giorni di scadenza della password 
	DECIDIM_ADMIN_PASSWORD_MIN_LENGTH: #Intero che segnala la lunghezza minima della password
	DECIDIM_ADMIN_PASSWORD_REPETITION_TIMES: #Intero che indica quante password amministrative già utilizzate vengono comparate alla password attuale
	DECIDIM_ADMIN_PASSWORD_STRONG: #Booleano che segnala se utilizzare le regole per la password strong
	API_SCHEMA_MAX_PER_PAGE: #Intero che definisce quanti items vengono restituiti al massimo da una query GraphQL API
	API_SCHEMA_MAX_COMPLEXITY: #Intero che segnala la complessità della query GraphQL
	API_SCHEMA_MAX_DEPTH: #Intero che segnala quante query GraphQL possano essere innestate 
	PROPOSALS_SIMILARITY_THRESHOLD: #Float che definisce la soglia di similarità di una proposta
	PROPOSALS_SIMILARITY_LIMIT: #Intero che definisce il limite di similarità di una proposta
	PROPOSALS_PARTICIPATORY_SPACE_HIGHLIGHTED_PROPOSALS_LIMIT: #Intero che definisce il numero massimo di proposte evidenziate
	PROPOSALS_PROCESS_GROUP_HIGHLIGHTED_PROPOSALS_LIMIT: #Intero che definisce il limite alle gruppo di proposte evidenziate
	MEETINGS_UPCOMING_MEETING_NOTIFICATION: #Intero che definisce quanti giorni prima vengono inviate notifiche riguardanti i meeting imminenti
	MEETINGS_ENABLE_PROPOSAL_LINKING: #Booleano che definisce se è possibile linkare le proposte nei meeting
	MEETINGS_EMBEDDABLE_SERVICES: #Stringa che definisce il servizio includibile nei Meeting
	BUDGETS_ENABLE_PROPOSAL_LINKING: #Stringa che definisce se le proposte siano linkabili al bilancio partecipativo
	ACCOUNTABILITY_ENABLE_PROPOSAL_LINKING: #Stringa che definisce se le proposte siano linkabili all'accountability
	CONSULTATIONS_STATS_CACHE_EXPIRATION_TIME: #Intero che definisce per quanti minuti le statistiche delle consultazioni sono messe in cache
	INITIATIVES_CREATION_ENABLED: #Stringa che definisce se la creazione delle iniziative é abilitata
	INITIATIVES_SIMILARITY_THRESHOLD: #Float che definisce la soglia di similarità delle iniziative
	INITIATIVES_SIMILARITY_LIMIT: #Intero che definisce il limite di similarità delle iniziative
	INITIATIVES_MINIMUM_COMMITTEE_MEMBERS: #Intero che definisce il numero minimo di membri di un comitato
	INITIATIVES_DEFAULT_SIGNATURE_TIME_PERIOD_LENGTH: #Intero che definisce la lunghezza del periodo di tempo della firma di default delle iniziative
	INITIATIVES_DEFAULT_COMPONENTS: #Stringa che definisce i componenti di default delle iniziative
	INITIATIVES_FIRST_NOTIFICATION_PERCENTAGE: #Intero che definisce a quale perscentuale di completamente viene inviata la prima notifica per le iniziative
	INITIATIVES_SECOND_NOTIFICATION_PERCENTAGE: #Intero che definisce a quale perscentuale di completamente viene inviata la seconda notifica per le iniziative
	INITIATIVES_STATS_CACHE_EXPIRATION_TIME: #Intero che determina per quanti minuti le statistiche delle iniziative sono messe in cache 
	INITIATIVES_MAX_TIME_IN_VALIDATING_STATE: #Intero che segnala il tempo massimo in giorni in cui una iniziativa può stare in stato di validazione
	INITIATIVES_PRINT_ENABLED: #Stringa che definisce se le iniziative sono stampabili
	INITIATIVES_DO_NOT_REQUIRE_AUTHORIZATION: #Booleano che definisce se le iniziative non richiedono autenticazione
	VERIFICATIONS_DOCUMENT_TYPES: #Stringa che definisce quali documenti sono abilitati alla verifica
	ELECTIONS_BULLETIN_BOARD_SERVER: #Stringa che definisce l'URL relativo al board server
	STORAGE_PROVIDER: #Stringa che definisce lo storage provider
	OMNIAUTH_FACEBOOK_APP_ID: #Stringa che definisce l'id relativo all'autenticazione su facebook via omniauth
	OMNIAUTH_TWITTER_API_KEY: #Stringa che definisce l'id relativo all'autenticazione su tweetter via omniauth
	OMNIAUTH_GOOGLE_CLIENT_ID: Stringa che definisce l'id relativo all'autenticazione su google via omniauth

## FAQ

Per verificare le risposte alle domande più frequenti, in particolare in relazione alla installazione della piattaforma, verificare le [FAQ.md](https://github.com/dipartimentofunzionepubblica/partecipa/blob/master/FAQ.md)

## Segnalazioni sulla sicurezza

ParteciPa utilizza tutte le raccomandazioni e le prescrizioni in materia di sicurezza previste da Decidim e dall’Agenzia per l’Italia Digitale per SPID. Per segnalazioni su possibili falle nella sicurezza del software riscontrate durante l'utilizzo preghiamo di usare il canale di comunicazione confidenziale attraverso l'indirizzo email partecipa@governo.it e non aprire segnalazioni pubbliche. E' indispensabile contestualizzare e dettagliare con la massima precisione le segnalazioni. Le segnalazioni anonime o non sufficientemente dettagliate non potranno essere verificate.

## ParteciPa

Le integrazioni e le personalizzazioni di ParteciPa che modificano Decidim sono state sviluppate da Formez PA. Per contatti scrivere a partecipa@governo.it .
