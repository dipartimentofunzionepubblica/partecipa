# FAQ

## Posso installare ParteciPa su qualsiasi sistema operativo?

I sistemi operativi testati sono principalmente varie versioni LTS di Ubuntu Server.
Questo di per se non esclude che ParteciPa possa funzionare con altre distribuzioni Linux ma non è in nessun modo garantito.

## Per installare ParteciPa devo aver prima installato Decidim? Posso usare la versione di Decidim che preferisco?

ParteciPa è una development app di Decidim che fa l'override di un certo numero di componenti di Decidim e include un certo numero di moduli opzionali. 
Questo significa che per ParteciPa Decidim è una dipendenza specificata nel Gemfile e si installa col bundle del progetto.

Per rendere possibile l'esecuzione di ParteciPa occorre che:
1) sia installata la versione di Ruby corretta prevista su ParteciPa nel file .ruby-version;
2) siano installati il Database PostGres, il Web Server NGINX e l'Application Server Passenger;
3) Decidim sia installato, nella versione presente nel Gemfile di ParteciPa. 
Non è possibile supportare altre versioni, pertanto il passo specifico alla installazione di Decidim nella guida all'installazione può essere omesso.

Si veda la guida all'installazione di Decidim a [questo indirizzo](https://platoniq.github.io/decidim-install/).

## Bundler mi restituisce un errore, come lo risolvo?

Bundler può restituire un errore principalmente perché è stata installata una diversa versione da quella utilizzata per creare il Gemfile.lock.
Per risolvere l'errore basta usare la stessa versione usata per il Gemfile.lock che è individuabile alla fine del file, ad es.:

BUNDLED WITH
   2.2.18

## Posso usare la versione di Ruby o di Rails che preferisco?

Entrambi gli strati di software devono essere obbligatoriamente aderenti alle versioni usate per ParteciPa:
1) nel caso di Ruby la versione precisata nel file .ruby-version nella root del progetto;
2) nel caso di Rails la versione è precisata nel Gemfile o nel Gemfile.lock e si installa con il bundle del progetto.

## Riscontro un problema sulle migrazioni, come posso risolverlo?

Se l'installazione avviene da zero su un database da creare è bene eliminare le precedenti migrazioni e far creare nuove migrazioni col comando

	bundle exec rails decidim:upgrade

e quindi:

	bundle exec rails db:migrate

Questi due comandi sono funzionali a creare nuovi script di migrazione e quindi creare la struttura del database.
Potrebbe essere necessario creare nuove migrazioni anche per i moduli inclusi nel Gemfile, quindi ad esempio per Decidim Awesome:

	bundle exec rails decidim_decidim_awesome:install:migrations
	
e quindi nuovamente:

	bundle exec rails db:migrate

Questo andrebbe fatto per tutti i moduli inclusi nel Gemfile che prevedano delle migrations ad hoc.
	
Se invece si sta facendo un aggiornamento di una versione di ParteciPa già esistente non è necessario, né indicato, ri-creare le migrations.

## Come posso compilare gli assets dell'applicativo?

Dalla versione 0.25.2 Decidim, e quindi ParteciPa, usano Webpacker per la gestione degli assets statici (immagini, JavaScript, CSS).

Per installare Webpacker occorre:

Installare:

	bundle exec rails webpacker:install

Installare l'estensione per Decidim Webpacker: 

	bundle exec rails decidim:webpacker:install
	
Per eseguire Webpacker e compilare gli assets:

	npm i
	bundle exec rails webpacker:compile

E' possibile far riferimento alla documentazione di Decidim per maggiori informazioni anche relative all'upgrade di versione di Decidim dalla versione 0.24.3
a [questo indirizzo](https://docs.decidim.org/en/develop/develop/guide_migrate_webpacker_app.html) .

## Riscontro dei problemi nella compilazione degli assets con Webpacker, come posso risolvere?

Prerequisito per il corretto funzionamento di Webpacker è l'installazione delle seguenti versioni di Node.js e Npm:

- NodeJs: versione 16.9.x (versione obbligatoria);
- Npm: versione: 7.21.x (versione minima).

Il rispetto di questi vincoli di versione è essenziale per poter compilare gli assets e far funzionare l'applicativo.
E' possibile far riferimento alla documentazione di Decidim per maggiori informazioni anche relative all'upgrade di versione di Decidim dalla versione 0.24.3
a [questo indirizzo](https://docs.decidim.org/en/develop/develop/guide_migrate_webpacker_app.html) .