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
* Framework: Ruby on Rails 5;
* Linguaggio: Ruby;
* Database: Postgres;
* Application Server: Passenger/Nginx.

I manuali di Amministrazione per Decidim si trovano nei seguenti URL:

https://decidim.org/docs/
https://docs.decidim.org/
	
Istruzioni dettagliate su come installare Decidim si trovano a [questo indirizzo](https://platoniq.github.io/decidim-install/).

Le seguenti istruzioni di installazione riguardano la sola installazione o aggiornamento di ParteciPa, successiva a quella di Decidim

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

* Utilizzo del [Sistema Pubblico di Identità Digitale (Spid)](https://www.spid.gov.it/) attraverso il middleware Open-Source [Spid-Rails](https://github.com/italia/spid-rails) ;
* Aspetto grafico ridefinito via SCSS;
* Modifiche sul profilo dell’utente per soddisfare le indicazioni del GDPR;
* Integrazione del modulo community [Term-Customizer](https://github.com/mainio/decidim-module-term_customizer);
* Installazione in modalità multi-tenant.
 
## Utilizzo del Sistema Pubblico di Identità Digitale (Spid)

Spid è il Sistema Pubblico di Identità Digitale basato sul linguaggio [SAML2](https://en.wikipedia.org/wiki/SAML_2.0). 
L'attivazione di partecipa.gov.it come Service Provider Spid ha necessitato della applicazione della procedura descritta dettagliatamente a [questo indirizzo](https://www.spid.gov.it/come-diventare-fornitore-di-servizi-pubblici-e-privati-con-spid).
L'utilizzo del codice di ParteciPa per l'attivazione di un nuovo Service Provider Spid dovrebbe seguire lo stesso iter.
E' consigliata un'attenta analisi delle [Regole Tecniche Spid](https://docs.italia.it/italia/spid/spid-regole-tecniche/it/stabile/index.html) per l'attivazione di ParteciPa con Spid, almeno nella sezione che riguarda il Service Provider (SP) Metadata e Identity Provider (IDP) Metadata,
con particolare riferimento agli elementi AssertionConsumerService, SingleLogoutService, AttributeConsumingService.

Per integrare Spid  ParteciPa utilizza il middleware Open-Source [Spid-Rails](https://github.com/italia/spid-rails) modificato in base alle esigenze riscontrate e integrato nel sistema via [OmniAuth](https://github.com/omniauth/omniauth).

ParteciPa utilizza l'autenticazione Spid al livello 1 e richiede due soli attributi utente: l'Indirizzo di posta elettronica e il Codice identificativo Spid.
La piattaforma non memorizza in alcun modo le credenziali Spid dell'utente; vengono tracciati in un apposito log gli eventi di registrazione, login e logout dell'Utente via Spid.
ParteciPa utilizza tutte le raccomandazioni prescritte da Spid per garantire la massima sicurezza nelle transazioni.

Per abilitare il login Spid alla piattafoma ParteciPa, la piattaforma deve essere configurata adeguatamente. In particolare a monte della procedura descritta dettagliatamente a [questo indirizzo](https://www.spid.gov.it/come-diventare-fornitore-di-servizi-pubblici-e-privati-con-spid)
è indispensabile che siano configurati i seguenti files:
- <partecipa_path>/config/application.yml contiene le informazioni essenziali per il sistema, si veda sotto per maggiori dettagli;
- <partecipa_path>/config/spid_acs_list.yml contiene gli elementi AssertionConsumerService che vengono inseriti nel SP metadata.xml;
- <partecipa_path>/config/spid_slo_list.yml contiene gli elementi SingleLogoutService che vengono inseriti nel SP metadata.xml;
- <partecipa_path>/config/spid_attr_serv_list.yml contiene gli elementi AttributeConsumingService che vengono inseriti nel SP metadata.xml;
- <partecipa_path>/config/spid_provider_list.yml contiene i path relativi alle immagini dei logo degli Identity Provider Spid e i nomi che li identificano;
- <partecipa_path>/config/idp_metadata/ path che contiene gli IDP metadata.xml da scaricare da [questo indirizzo](https://www.agid.gov.it/it/piattaforme/spid/identity-provider-accreditati) ;
- <partecipa_path>/lib/.keys path nel quale è necessario inserire i certificati SHA256, SHA384 o SHA512 in formato .pem, creati come descritto sotto;
- <partecipa_path>/config/signed_sp_metadata path nel quale deve essere inserito il file "metadata-signed.xml" ottenuto dalla firma del file metadata pubblicato dal sistema, come indicato sotto.

Il file secrets.yml funge da collettore di tutte le costanti importandole da application.yml e non deve essere editato.
Perchè l'applicativo inizializzi Spid è necessario impostare la costante SPID_ENABLED a true; se impostata a false l'applicativo non leggerà i files e le configurazioni necessarie al funzionamento di Spid.  Con Spid inizializzato è possibile abilitare e disabilitare il provider Spid agendo dall'interfaccia di Amministratore di Sistema. 

## Aspetto grafico ridefinito via SCSS

L'aspetto grafico di ParteciPa è stato ridefinito rispettando quanto previsto dalle [Linee Guida per il design dei siti PA](https://www.agid.gov.it/it/argomenti/linee-guida-design-pa).

## Modifiche sul profilo dell’utente per soddisfare le indicazioni del GDPR

Per meglio salvaguardare la privacy dei partecipanti ai processi di consultazione sono stati realizzati degli interventi che consentono a ParteciPa di soddisfare al meglio le indicazioni italiane per l’applicazione del GDPR:
* Rimozione della possibilità per l’utente di caricare avatar personalizzato;
* Eliminazione della visibilità  del profilo pubblico Utente;
* Rimozione della funzionalità che permette  di "seguire" un Utente;
* Rimozione della funzionalità di ricerca tra gli utenti.

## Integrazione del modulo community Term-Customizer

Decidim utilizza un sistema centralizzato di definizione della localizzazione della piattaforma attraverso [Crowdin](https://crowdin.com/) nel quale le traduzioni sono applicabili indistintamente a tutte le istanze della piattaforma nella lingua data.
Il modulo community [Term-Customizer](https://github.com/mainio/decidim-module-term_customizer) può essere utilizzato per creare traduzioni applicabili alla sola istanza della piattaforma che si sta utilizzando.

## Installazione in modalità multi-tenant

Una stessa istanza di Decidim può essere utilizzata per più Organizzazioni in modalità multi-tenant. Le diverse Organizzazioni afferenti alla stessa istanza condividono aspetto grafico e localizzazione ma sono completamente slegate dal punto di vista delle informazioni immesse al loro interno e per quanto riguarda gli utenti registrati. Ciascuna Organizzazione risponde ad un diverso indirizzo.

## application.yml

Il file <partecipa_path>/config/application.yml contiene le principali configurazioni indispensabili per il funzionamento dell'applicativo.
La creazione e la redazione del file è a cura di chi installa la piattaforma secondo le indicazioni sotto, il file non è compreso nel repository.
Di seguito una breve spiegazione per ciascuna costante:

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

	GEOCODER_API_KEY: #here_api_key relativo al Geocoder Here vedere https://github.com/decidim/decidim/blob/0.21-stable/docs/services/geocoding.md
	
	SPID_ENABLED: #true o false, definisce se il corrispondente initializer caricherà tutti i files necessari ad attivare Spid; da impostare a false se i files stessi non sono presenti nel sistema
	SPID_HOSTNAME: #Corrisponde all'URL dell'HP della piattaforma, nel caso specifico "https://partecipa.gov.it", questa URL viene usato da SpidRails per accodare i path indicati sotto e per fornire la pagina di redirect dal logout Spid
	SPID_ENTITY_ID: #Normalmente è uguale a SPID_HOSTNAME, nel caso specifico è stato utile differenziarlo in modo da disaccoppiarlo. Nei sistemi AgID Identifica il metadata univocamente.
	SPID_METADATA_PATH: #Concatenato al SPID_HOSTNAME è l'indirizzo del metadata.xml, normalmente e secondo regole Spid "/metadata"
	SPID_LOGIN_PATH:  #Concatenato al SPID_HOSTNAME è l'URL relativa alla login, normalmente "/spid/login"
	SPID_LOGOUT_PATH: #Concatenato al SPID_HOSTNAME è l'URL relativa alla logout, normalmente "/spid/logout"
	
	SPID_ACS_INDEX: #L'AssertionConsumerServiceIndex che verrà inviato nella Request all'Identity Provider. Identifica il servizio a cui fare login. Si riferisce all'Array di Hash di AssertionConsumerService costruito con il file spid_acs_list.yml con indice basato a 0
    SPID_SLO_INDEX: #L'indice che identifica il SingleLogoutService verso la quale indirizzare il logout. Si riferisce all'Array di Hash di SingleLogoutService costruito con il file spid_slo_list.yml con indice basato a 0
	
	SPID_DEFAULT_RELAY_STATE_PATH: #Concatenato al SPID_HOSTNAME è l'indirizzo della callback relativa alla autenticazione via OmniAuth, normalmente "/users/auth/spidauth/callback"
	SPID_SIGNATURE_METHOD: #Secondo preferenza tra "Spid::RSA_SHA256", "Spid::RSA_SHA384", "Spid::RSA_SHA512"
	
	SPID_LEVEL: #Livello Spid, può essere valorizzato con "Spid::L1", "Spid::L2" o "Spid::L3", normalmente "Spid::L1"; consultare la documentazione Spid per approfondimenti
	SPID_ATTR_SERV_LIST_INDEX: #L'indice che identifica il AttributeConsumingService, ossia il set di attributi, da usare, tra quelli previsti nel file spid_attr_serv_list.yml, con indice basato a 0

	SPID_ORGANIZATION_NAME: #Nome dell'Organizzazione che compare sul metadata.xml
	SPID_ORGANIZATION_DISPLAY_NAME: #Nome dell'Organizzazione che compare sul metadata.xml e che verrà trasmesso agli IDP
	SPID_ORGANIZATION_URL: #Sito dell'Organizzazione che compare sul metadata.xml

## spid_acs_list.yml

Il file <partecipa_path>/config/spid_acs_list.yml contiene una rappesentazione YAML di un Array di Hash in Ruby contenente tutti gli elementi AssertionConsumerService da inserire nel SP metadata.xml.
Il file deve mantenere la stessa struttura e le stesse chiavi.
Per approfondimenti si vedano le specifiche [YAML](https://en.wikipedia.org/wiki/YAML).

Esempio:

	---
	acs_list: 
	  - 
		acs_url: https://partecipa.gov.it/spid/samlsso
		acs_binding: #urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST o urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect

## spid_slo_list.yml

Il file <partecipa_path>/config/spid_slo_list.yml contiene una rappesentazione YAML di un Array di Hash in Ruby contenente tutti gli elementi SingleLogoutService da inserire nel SP metadata.xml.
Il file deve mantenere la stessa struttura e le stesse chiavi.
Per approfondimenti si vedano le specifiche [YAML](https://en.wikipedia.org/wiki/YAML).

Esempio:

	---
	slo_list: 
	  - 
		slo_url: https://partecipa.gov.it/spid/samlslo
		slo_binding: #urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST o urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect
		response_location: https://partecipa.gov.it

## spid_attr_serv_list.yml

Il file <partecipa_path>/config/spid_attr_serv_list.yml contiene una rappesentazione YAML di un Array di Hash in Ruby contenente tutti gli elementi AttributeConsumingService da inserire nel SP metadata.xml
Il file deve mantenere la stessa struttura e le stesse chiavi.
Per approfondimenti si vedano le specifiche [YAML](https://en.wikipedia.org/wiki/YAML).

Esempio:

	---
	attr_serv_list:
	  - 
		name: Decidim
		fields: 
		  - :spid_code
		  - :email

## spid_provider_list.yml

Il file <partecipa_path>/config/spid_provider_list.yml contiene una rappesentazione YAML di un Array di Hash in Ruby contenente tutti le informazioni necessarie per costruire il menù che risponde
al click sul pulsante "Entra con Spid". Non è necessario editarlo in nessun modo se non per aggiungere un nuovo IDP, per esempio in fase di test.
Il file deve mantenere la stessa struttura e le stesse chiavi.
Per approfondimenti si vedano le specifiche [YAML](https://en.wikipedia.org/wiki/YAML).

Di seguito un estratto:

	--- 
	spid_provider_list: 
	  - 
		alt: "Aruba ID"
		identity_provider: aruba
		png_image_path: decidim/spid/spid-idp-arubaid.png
		svg_image_path: decidim/spid/spid-idp-arubaid.svg

Le immagini sono già contenute sotto il percorso <partecipa_path>/app/assets/images/decidim/spid

## IDP metadata.xml

I metadata relativi agli Identity Providers Spid devono essere inseriti nella directory <partecipa_path>/config/idp_metadata rispettando la nomenclatura <nome_idp_minuscolo>id-metadata.xml senza spazi, ad esempio per Aruba sarà "arubaid-metadata.xml".
I metadata aggiornati sono pubblicati su [questo indirizzo](https://www.agid.gov.it/it/piattaforme/spid/identity-provider-accreditati). 
Per il corretto funzionamento di Spid è indispensabile che gli IDP metadata.xml siano aggiornati.

## Creazione dei certificati

I certificati indispensabili all'utilizzo di Spid devono essere generati con il seguente comando (nel caso specifico si tratta di certificati sha512):

	openssl req -x509 -nodes -sha512 -subj '/C=IT' -newkey rsa:4096 -keyout private_key.pem -out certificate.pem

I certificati devono essere contenuti nell'alberatura <partecipa_path>/lib/.keys.

## SP metadata.xml

Una volta compilati i dati relativi ai files sopra e una volta creati i certificati come sopra, ParteciPa è in grado di pubblicare il SP metadata.xml all'URL previsto nel file application.yml, come valore della costante SPID_METADATA_PATH (secondo le regole tecniche https://<URL_partecipa>/metadata).
Il file SP metadata.xml così pubblicato per essere trasmesso ad AgID perché diventi parte della federazione Spid deve essere:

1) validato con l'apposito tool [spid-validator](https://github.com/italia/spid-saml-check/tree/master/spid-validator);
2) firmato con l'apposito tool [spid-metadata-signer](https://github.com/italia/spid-metadata-signer);
3) rinominato in "metadata-signed.xml";
4) pubblicato sull'apposito path <partecipa_path>/config/signed_sp_metadata.

Il nuovo file SP metadata.xml così modificato e firmato sarà disponibile all'URL previsto nel file application.yml, come valore della costante SPID_METADATA_PATH.
Il SP metadata.xml dovrà poi essere collaudato da AgID in base alla già citata procedura disponibile a [questo indirizzo](https://www.spid.gov.it/come-diventare-fornitore-di-servizi-pubblici-e-privati-con-spid).

## Segnalazioni sulla sicurezza

ParteciPa utilizza tutte le raccomandazioni e le prescrizioni in materia di sicurezza previste da Decidim e dall’Agenzia per l’Italia Digitale per SPID. Per segnalazioni su possibili falle nella sicurezza del software riscontrate durante l'utilizzo preghiamo di usare il canale di comunicazione confidenziale attraverso l'indirizzo email security-partecipa@formez.it e non aprire segnalazioni pubbliche. E' indispensabile contestualizzare e dettagliare con la massima precisione le segnalazioni. Le segnalazioni anonime o non sufficientemente dettagliate non potranno essere verificate.

## ParteciPa

Le integrazioni e le personalizzazioni di ParteciPa che modificano Decidim sono state sviluppate da Formez PA. Per contatti scrivere a  maintainer-partecipa@formez.it.