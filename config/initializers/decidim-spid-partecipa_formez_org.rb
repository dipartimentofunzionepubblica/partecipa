# Copyright (C) 2022 Formez PA
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# frozen_string_literal: true

Decidim::Spid.configure do |config|
  # Definisce il nome del tenant. Solo lettere minuscole e underscores sono permessi.
  # Default: spid. Quando hai multipli tenant devi definire un nome univoco rispetto ai vari tenant.
  config.name = ENV['SPID_TENANT_NAME']

  # Definisce l'entity ID del service provider:
  # config.sp_entity_id = "https://www.example.org/users/auth/spid/metadata"
  config.sp_entity_id = ENV['SPID_ENTITY_ID'] 

  # Le chiavi che verranno salvate sul DB nell'autorizzazione
  config.metadata_attributes = {
    name: "name",
    surname: "familyName",
    fiscal_code: "fiscalNumber",
    gender: "gender",
    birthday: "dateOfBirth",
    birthplace: "placeOfBirth",
    company_name: "companyName",
    registered_office: "registeredOffice",
    iva_code: "ivaCode",
    id_card: "idCard",
    mobile_phone: "mobilePhone",
    email: "email",
    address: "address",
    digital_address: "digitalAddress"
  }

  # I campi da escludere dall'export nei processi a causa della policy GDPR.
  # Deve contenere un'array di chiavi presenti in metadata_attributes.
  # Se l'array è vuoto saranno inseriti tutti quelli disponibili
  config.export_exclude_attributes = [
    :name, :surname, :fiscal_code, :company_name, :registered_office, :email, :iva_code
  ]

  # Percorso relativo alla root dell'app della chiave privata
  config.private_key_path = "lib/.keys/private_key.pem"

  # Percorso relativo alla root dell"app del certificato
  config.certificate_path = "lib/.keys/certificate.pem"

  # Percorso relativo alla root dell'app del nuovo certificato
  config.new_certificate_path = nil

  # Livello di crittografia SHA per la generazione delle signature
  config.sha = ENV['SPID_SIGNATURE_METHOD']

  # Attribute to match user
  config.uid_attribute = :spidCode

  # Il livello SPID richiesto dall'app
  config.spid_level = ENV['SPID_LEVEL']

  # Link per reindirizzare dopo il login
  config.relay_state = "/"

  # Documentazione https://docs.italia.it/italia/spid/spid-regole-tecniche/it/stabile/metadata.html#service-provider
  # Configurazioni relative al service provider. it obbligatorio
  config.organization = {
    it: { name: ENV['SPID_ORGANIZATION_NAME'], display: ENV['SPID_ORGANIZATION_DISPLAY_NAME'], url: ENV['SPID_ORGANIZATION_URL'] }
  }
  
  # Documentazione https://docs.italia.it/italia/spid/spid-regole-tecniche/it/stabile/metadata.html#service-provider
  # Verificare obbligatorietà degli attributi in combinazione tra loro
  # Esempio: {
  #   public: true, ipa_code: "IT12345678901", vat_number: "IT12345678901",
  #   fiscal_code: "XCGBCH47H29H072B", given_name: "SPID Test Team", email: "email@exaple.com",
  #   company: "Nome organizzazione S.p.a", number: "+39061111111"
  # }
  config.contact_people_other = {
    public: true, ipa_code: ENV['SPID_CONTACT_PERSON_IPA_CODE'], vat_number: ENV['SPID_CONTACT_PERSON_VAT_NUMBER'],
    fiscal_code: ENV['SPID_CONTACT_PERSON_FISCAL_CODE'], given_name: ENV['SPID_CONTACT_PERSON_GIVEN_NAME'], email: ENV['SPID_CONTACT_PERSON_EMAIL'],
    company: ENV['SPID_CONTACT_PERSON_COMPANY'], number: ENV['SPID_CONTACT_PERSON_NUMBER']
  }

  # Obbligatorio solo per soggetti privati
  config.contact_people_billing = {}

  # Dati dell'utente richiesti all'identity provider
  # Obbligatorio email.
  config.fields = [
    { name: "name", friendly_name: "Nome", is_required: true },
    { name: "familyName", friendly_name: "Cognome", is_required: true },
    { name: "fiscalNumber", friendly_name: "Codice Fiscale", is_required: true },
    { name: "spidCode", friendly_name: "Codice SPID", is_required: true },
    { name: "email", friendly_name: "Email", is_required: true },
    { name: "gender", friendly_name: "Genere", is_required: true },
    { name: "dateOfBirth", friendly_name: "Data di nascita", is_required: true },
    { name: "placeOfBirth", friendly_name: "Luogo di nascita", is_required: true },
    { name: "registeredOffice", friendly_name: "registeredOffice", is_required: true },
    { name: "ivaCode", friendly_name: "Partita IVA", is_required: true },
    { name: "idCard", friendly_name: "ID Carta", is_required: true },
    { name: "mobilePhone", friendly_name: "Numero di telefono", is_required: true },
    { name: "address", friendly_name: "Indirizzo", is_required: true },
    { name: "digitalAddress", friendly_name: "Indirizzo digitale", is_required: true }
  ]

  #######################################
  # In caso di di metadata esistente e con servizi multupli utilizzare le seguenti configurazioni

  # Per aggiungere più AssertionConsumerService
   config.consumer_services = [
     { 'Location' => 'https://partecipa.gov.it/spid/samlsso', 'Binding' => 'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST' },
     { 'Location' => 'https://partecipa.formez.org/spid/samlsso', 'Binding' => 'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST' },
     { 'Location' => 'https://www.ripam.cloud/api/spid/login', 'Binding' => 'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST' },
   ]
  
  # Per aggiungere più SingleLogoutService
  # ResponseLocation opzionale
   config.logout_services = [
     { 'Location' => 'https://partecipa.gov.it/spid/samlslo', 'Binding' => 'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect', 'ResponseLocation' => 'https://partecipa.gov.it' },
     { 'Location' => 'https://partecipa.formez.org/spid/samlslo', 'Binding' => 'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect', 'ResponseLocation' => 'https://partecipa.formez.org' },
     { 'Location' => 'https://www.ripam.cloud/api/spid/logout', 'Binding' => 'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST' }
   ]
  
  # Per customizzare il path del metadata
   config.metadata_path = ENV['SPID_METADATA_PATH'] 

  # Indicare l'indice dell'array del servizio da utilizzare per questo tenant
  # Default value: 0. Indice per il AssertionConsumerService di default
  config.default_service_index = ENV['SPID_DEFAULT_ACS_INDEX'].to_i
  # Default value: 0. Indicare l'indice (dell'array config.consumer_services) per il AssertionConsumerService da utilizzare per questo tenant
  config.current_consumer_index = ENV['SPID_ACS_INDEX'].to_i
  # Default value: 0. Indicare l'indice (dell'array config.attribute_services) per il AttributeConsumingServiceIndex da utilizzare per questo tenant
  config.current_attribute_index = ENV['SPID_ATTR_SERV_LIST_INDEX'].to_i
  # Default value: 0. Indicare l'indice (dell'array config.logout_services) per il SingleLogoutService da utilizzare per questo tenant
  config.current_logout_index = ENV['SPID_SLO_INDEX'].to_i

  # In caso di più AttributeConsumingService
  # Attenzione: l'ordinamento è fondamentale per associare il giusto nome agli attributi specificati in seguito.
  # Obbligatorio email.
  config.attribute_service_names = [ "Decidim", "Step One Authentication" ]
  config.attribute_services = [
     [
       { name: "spidCode" },
       { name: "email" }
     ],
	 [
       { name: "name" },
       { name: "familyName" },
       { name: "fiscalNumber" },
       { name: "spidCode" },
       { name: "email" },
       { name: "gender" },
       { name: "dateOfBirth" },
       { name: "placeOfBirth" },
       { name: "registeredOffice" },
       { name: "ivaCode" },
       { name: "idCard" },
       { name: "mobilePhone" },
       { name: "address" },
       { name: "digitalAddress" }
     ]
   ]
end
