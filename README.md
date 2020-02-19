# Partecipa

## Piattaforma di partecipazione democratica

Partecipa è la piattaforma di partecipazione democratica promossa dalla Repubblica Italiana.

## Software

Partecipa è un progetto Open-Source basato su [Decidim](https://github.com/decidim/decidim), la piattaforma di partecipazione democratica creata dalla città di Barcellona e
diffusa in tutto il mondo. Decidim è concesso in licenza attraverso la [GNU Affero General Public License v3.0](https://github.com/decidim/decidim/blob/develop/LICENSE-AGPLv3.txt).
Prima di installare e utilizzare Partecipa raccomandiamo un attento esame della documentazione relativa a Decidim e di questo README.

Dal punto di vista tecnico Decidim è basato su:
* Framework: Ruby on Rails 5;
* Linguaggio: Ruby;
* Database: Postgres;
* Application Server: Passenger/Nginx.

I manuali di Amministrazione per Decidim si trovano nei seguenti URL:

    https://decidim.org/docs/
    https://docs.decidim.org/
	
Istruzioni dettagliate su come installare Decidim si trovano a [questo indirizzo](https://platoniq.github.io/decidim-install/).

## Modifiche e integrazioni di Partecipa rispetto a Decidim

Partecipa usa il core di Decidim 0.19.0 e personalizza o integra solo i seguenti aspetti:

* Utilizzo del [Sistema Pubblico di Identità Digitale (Spid)](https://www.spid.gov.it/) attraverso il middleware [Spid-Rails](https://github.com/italia/spid-rails) modificato in base alle esigenze riscontrate e integrato nel sistema via [OmniaAuth](https://github.com/omniauth/omniauth);
* Aspetto grafico ridefinito via SCSS;
* Modifiche sulla base delle osservazioni del Garante della Privacy;
* Integrazione del modulo community [Term-Customizer](https://github.com/mainio/decidim-module-term_customizer);
* Installazione in modalità multi-tenant.
 
## Utilizzo del Sistema Pubblico di Identità Digitale (Spid)

Spid è il Sistema Pubblico di Identità Digitale basato sul linguaggio [SAML2](https://en.wikipedia.org/wiki/SAML_2.0). 
L'attivazione di partecipa.gov.it come Service Provider Spid ha necessitato della applicazione della procedura descritta dettagliatamente a [questo indirizzo](https://www.spid.gov.it/come-diventare-fornitore-di-servizi-pubblici-e-privati-con-spid).
L'utilizzo del codice di Partecipa per l'attivazione di un nuovo Service Provider Spid dovrebbe seguire lo stesso iter.
Partecipa utilizza l'autenticazione Spid al livello 1 e richiede due soli attributi utente: l'Indirizzo di posta elettronica e il Codice identificativo SPID.
La piattaforma non conosce né memorizza in nessun modo le credenziali Spid dell'utente; vengono tracciati in un apposito log gli eventi di registrazione, login e logout dell'Utente via Spid.
Partecipa utilizza tutte le raccomandazioni prescritte da Spid per garantire la massima sicurezza nelle transazioni.

## Aspetto grafico ridefinito via SCSS

L'aspetto grafico di Partecipa è stato ridefinito rispettando quanto previsto dalle [Linee Guida per il design dei siti PA](https://www.agid.gov.it/it/argomenti/linee-guida-design-pa).

## Modifiche sulla base delle osservazioni del Garante della Privacy 

Le seguenti modifiche sono state richieste dal Garante della Privacy con l'obbiettivo di salvaguardare maggiormente i partecipanti ai processi di partecipazione democratica:

* Rimozione dell'Avatar Utente;
* Rimozione del profilo pubblico Utente, in modo che l'attività degli utenti sulla piattaforma non sia pubblica;
* Rimozione della possibilità di "seguire" un Utente, è possibile "seguire" solo i Processi;
* Rimozione della possibilità di cercare un Utente.

## Integrazione del modulo community Term-Customizer

Decidim utilizza un sistema centralizzato di definizione della localizzazione della piattaforma attraverso [Crowdin](https://crowdin.com/). Il modulo community Term-Customizer può essere utilizzato per creare traduzioni applicabili alla sola istanza della piattaforma che si sta utilizzando.

## Installazione in modalità multi-tenant

La stessa istanza di Decidim può essere utilizzata per più Organizzazioni in modalità multi-tenant. Le diverse Organizzazioni afferenti alla stessa istanza condividono aspetto grafico e localizzazione ma sono completamente slegate dal punto di vista delle informazioni immesse al loro interno.

## Application.yml

Il file <decidim_path>/config/application.yml contiene le principali configurazioni indispensabili per il funzionamento dell'applicativo.
Di seguito una breve spiegazione attributo per attributo:

	SECRET_KEY_BASE: #Secret key utilizzata da Rails per il suo funzionamento vedere https://medium.com/@michaeljcoyne/understanding-the-secret-key-base-in-ruby-on-rails-ce2f6f9968a1
	GOOGLE_ANALYTICS_ID: #Google Analytics ID di monitoraggio vedere https://support.google.com/analytics/answer/7372977

	DATABASE_URL: #URL del DB nella seguente forma "postgres://<DATABASE_USERNAME>:<DATABASE_PASSWORD>@<DATABASE_HOST>/<DATABASE_NAME>"
	DATABASE_HOST: #Host che ospita il DB
	DATABASE_USERNAME: #Username del DB
	DATABASE_PASSWORD: #Password del DB

	SMTP_USERNAME: #Username dell'account di posta utilizzato per la spedizione delle mail della piattaforma via SMTP
	SMTP_PASSWORD: #Password dell'account di posta
	SMTP_ADDRESS: #Indirizzo dell'SMTP
	SMTP_DOMAIN: #Dominio dell'SMTP

	GEOCODER_LOOKUP_APP_ID: #AppID relativo al Geocoder Here vedere https://github.com/decidim/decidim/blob/master/docs/services/geocoding.md
	GEOCODER_LOOKUP_APP_CODE: #AppCode relativo al Geocoder Here

	SPID_HOSTNAME: #Corrisponde all'URL dell'HP della piattaforma, nel caso specifico "https://partecipa.gov.it", quest'URL viene usato da SpidRails per accodare i path indicati sotto e per fornire la pagina di redirect dal logout Spid
	SPID_ENTITY_ID: #Normalmente è uguale a SPID_HOSTNAME, nel caso specifico è stato utile differenziarlo 
	SPID_METADATA_PATH: #Concatenato al SPID_HOSTNAME è l'indirizzo del metadata.xml, normalemente "/metadata"
	SPID_LOGIN_PATH:  #Concatenato al SPID_HOSTNAME è l'URL relativo alla login, normalmente "/spid/login"
	SPID_LOGOUT_PATH: #Concatenato al SPID_HOSTNAME è l'URL relativo alla logout, normalmente "/spid/logout"
	SPID_ACS_PATH: #Concatenato al SPID_HOSTNAME è l'URL relativo al AssertionConsumerService, normalmente "/spid/samlsso"
	SPID_SLO_PATH: #Concatenato al SPID_HOSTNAME è l'URL relativo al LogoutService, normalmente "/spid/samlslo"
	SPID_DEFAULT_RELAY_STATE_PATH: #Concatenato al SPID_HOSTNAME è l'indirizzo della callback relativa alla autenticazione via OmniAuth, normalmente "/users/auth/spidauth/callback"
	SPID_DIGEST_METHOD: #Secondo preferenza tra "Spid::SHA256", "Spid::SHA384", "Spid::SHA512"
	SPID_SIGNATURE_METHOD: #Secondo preferenza tra "Spid::SHA256", "Spid::SHA384", "Spid::SHA512"
	SPID_ACS_BINDING: #Normalmente "Spid::BINDINGS_HTTP_REDIRECT"
	SPID_SLO_BINDING: #Normalmente "Spid::BINDINGS_HTTP_REDIRECT"
	SPID_ORGANIZATION_NAME: #Nome dell'Organizzazione che compare sul metadata.xml
	SPID_ORGANIZATION_DISPLAY_NAME: #Nome dell'Organizzazione che compare sul metadata.xml e che verrà trasmesso agli IDP
	SPID_ORGANIZATION_URL: #Sito dell'Organizzazione che compare sul metadata.xml

## IDP metadata.xml

I metadata relativi agli Identity Providers Spid devono essere inseriti nella directory <decidim_path>/config/idp_metadata rispettando la nomenclatura <NOME_IDP>id-metadata.xml.
I metadata aggiornati sono pubblicati su [questo indirizzo](https://www.agid.gov.it/it/piattaforme/spid/identity-provider-accreditati). Per il corretto funzionamento di Spid è indispensabile l'aggiornamento degli IDP metadata.

## Creazione dei certificati

I certificati indispensabili all'utilizzo di Spid devono essere generati con il seguente comando (nel caso specifico si tratta di certificati sha512):

	openssl req -x509 -nodes -sha512 -subj '/C=IT' -newkey rsa:4096 -keyout private_key.pem -out certificate.pem

I certificati devono essere contenuti nell'alberatura <decidim_path>/lib/.keys.