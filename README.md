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

* Utilizzo del [Sistema Pubblico di Identità Digitale (Spid)](https://www.spid.gov.it/) attraverso la gem Open-Source [Decidim-Spid-Cie](https://github.com/dipartimentofunzionepubblica/decidim-module-spid-cie) ;
* Aspetto grafico ridefinito via SCSS;
* Modifiche sul profilo dell’utente per soddisfare le indicazioni del GDPR;
* Integrazione dei moduli community [Term-Customizer](https://github.com/mainio/decidim-module-term_customizer), [Decidim-Awesome](https://github.com/Platoniq/decidim-module-decidim_awesome), [Decidim-Analytics](https://github.com/digidemlab/decidim-module-analytics) e [Decidim-Privacy](https://github.com/dipartimentofunzionepubblica/decidim-module-privacy);
* Installazione in modalità multi-tenant.
 
## Utilizzo del Sistema Pubblico di Identità Digitale (Spid)

Spid è il Sistema Pubblico di Identità Digitale basato sul linguaggio [SAML2](https://en.wikipedia.org/wiki/SAML_2.0). 
L'attivazione di partecipa.gov.it come Service Provider Spid ha necessitato della applicazione della procedura descritta dettagliatamente a [questo indirizzo](https://www.spid.gov.it/cos-e-spid/diventa-fornitore-di-servizi/).
L'utilizzo del codice di ParteciPa per l'attivazione di un nuovo Service Provider Spid dovrebbe seguire lo stesso iter.
E' consigliata un'attenta analisi delle [Regole Tecniche Spid](https://docs.italia.it/italia/spid/spid-regole-tecniche/it/stabile/index.html) per l'attivazione di ParteciPa con Spid, almeno nella sezione che riguarda il Service Provider (SP) Metadata e Identity Provider (IDP) Metadata,
con particolare riferimento agli elementi AssertionConsumerService, SingleLogoutService, AttributeConsumingService.

Per integrare Spid  ParteciPa utilizza il middleware Open-Source [Decidim-Spid-Cie](https://github.com/dipartimentofunzionepubblica/decidim-module-spid-cie) .

ParteciPa utilizza l'autenticazione Spid al livello 1 e richiede due soli attributi utente: l'Indirizzo di posta elettronica e il Codice identificativo Spid.
La piattaforma non memorizza in alcun modo le credenziali Spid dell'utente; vengono tracciati in un apposito log contenuto nel Database gli eventi di registrazione, login e logout dell'Utente via Spid.
ParteciPa utilizza tutte le raccomandazioni prescritte da Spid per garantire la massima sicurezza nelle transazioni.

Per abilitare il login Spid alla piattafoma ParteciPa, la piattaforma deve essere configurata adeguatamente. In particolare a monte della procedura descritta dettagliatamente a [questo indirizzo](https://www.spid.gov.it/cos-e-spid/diventa-fornitore-di-servizi/)
è indispensabile che sia configurato il file <partecipa_path>/config/application.yml che contiene le informazioni essenziali per il sistema, si veda sotto per maggiori dettagli.

Il file secrets.yml funge da collettore di tutte le costanti importandole da application.yml e non deve essere editato.
Si rimanda al README.md della gem [Decidim-Spid-Cie](https://github.com/dipartimentofunzionepubblica/decidim-module-spid-cie) per i dettagli relativi alla configurazione del sistema con SPID.

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
Il modulo community [Decidim-Analytics](https://github.com/digidemlab/decidim-module-analytics) da la possibilità di visualizzare la Dashboard Matomo direttamente nella vista Ammnistrativa di Decidim. 
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
	MATOMO_TOKEN_AUTH: #Stringa che identifica la Dashboard Matomo
	
	DATABASE_URL: #URL del DB nella seguente forma "postgres://<DATABASE_USERNAME>:<DATABASE_PASSWORD>@<DATABASE_HOST>/<DATABASE_NAME>"
	DATABASE_HOST: #Host che ospita il DB
	DATABASE_USERNAME: #Username del DB
	DATABASE_PASSWORD: #Password del DB

	SMTP_USERNAME: #Username dell'account di posta utilizzato per la spedizione delle mail della piattaforma via SMTP
	SMTP_PASSWORD: #Password dell'account di posta
	SMTP_ADDRESS: #Indirizzo dell'SMTP
	SMTP_DOMAIN: #Dominio dell'SMTP

	GEOCODER_API_KEY: #here_api_key relativo al Geocoder Here vedere https://github.com/decidim/decidim/blob/0.21-stable/docs/services/geocoding.md
	
	SPID_TENANT_NAME: #Stringa che identifica il nome del tenant SPID
	SPID_BUTTON_SIZE: #Stringa ["s","m","l","xl"] che determina la dimensione del bottone SPID
	SPID_ENTITY_ID: #Stringa che identifica univocamente il metadata SPID relativo alla Organizzazione
	SPID_METADATA_PATH: #URL del metadata SPID
	SPID_SIGNATURE_METHOD: #Intero che identifica lo SHA utilizzato per la firma
	SPID_DEFAULT_ACS_INDEX: #Intero, indice del AssertionConsumerService di default
	SPID_ACS_INDEX: #Intero, indice dell'elemento nell'array di AssertionConsumerService usato
	SPID_SLO_INDEX: #Intero, indice dell'elemento nell'array di SingleLogoutService usato
	SPID_ATTR_SERV_LIST_INDEX: #Intero, indice dell'elemento nell'array attributi usato
	SPID_LEVEL: #Intero indicante il Livello SPID
	SPID_ORGANIZATION_NAME: #Stringa, nel metadata, il nome dell'Organizzazione
	SPID_ORGANIZATION_DISPLAY_NAME: #Stringa, nel metadata, il nome dell'Organizzazione visualizzato
	SPID_ORGANIZATION_URL: #Stringa, nel metadata l'URL dell'Organizzazione
	SPID_CONTACT_PERSON_IPA_CODE: #Stringa, nel metadata il codice IPA
	SPID_CONTACT_PERSON_VAT_NUMBER: #Stringa, nel metadata la partita IVA
	SPID_CONTACT_PERSON_FISCAL_CODE: #Stringa, nel metadata il codice fiscale
	SPID_CONTACT_PERSON_GIVEN_NAME: #Stringa, nel metadata il nome della persona
	SPID_CONTACT_PERSON_COMPANY: #Stringa, nel metadata il nome dell'Organizzazione
	SPID_CONTACT_PERSON_NUMBER: #Stringa, nel metadata il numero di telefono dell'Organizzazione

## Creazione dei certificati

I certificati indispensabili all'utilizzo di Spid devono essere generati con il seguente comando (nel caso specifico si tratta di certificati sha512):

	openssl req -x509 -nodes -sha512 -subj '/C=IT' -newkey rsa:4096 -keyout private_key.pem -out certificate.pem

I certificati devono essere contenuti nell'alberatura <partecipa_path>/lib/.keys.

## Segnalazioni sulla sicurezza

ParteciPa utilizza tutte le raccomandazioni e le prescrizioni in materia di sicurezza previste da Decidim e dall’Agenzia per l’Italia Digitale per SPID. Per segnalazioni su possibili falle nella sicurezza del software riscontrate durante l'utilizzo preghiamo di usare il canale di comunicazione confidenziale attraverso l'indirizzo email security-partecipa@formez.it e non aprire segnalazioni pubbliche. E' indispensabile contestualizzare e dettagliare con la massima precisione le segnalazioni. Le segnalazioni anonime o non sufficientemente dettagliate non potranno essere verificate.

## ParteciPa

Le integrazioni e le personalizzazioni di ParteciPa che modificano Decidim sono state sviluppate da Formez PA. Per contatti scrivere a  maintainer-partecipa@formez.it.
