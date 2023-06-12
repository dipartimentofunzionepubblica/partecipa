# Copyright (C) 2023 Formez PA
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# frozen_string_literal: true

if ENV['PUA_TENANT_NAME'].present?
	Decidim::Pua.configure do |config|
	  # Definisce il nome del tenant. Solo lettere minuscole e underscores sono permessi.
	  # Default: pua. Quando hai multipli tenant devi definire un nome univoco rispetto ai vari tenant.
	  config.name = ENV['PUA_TENANT_NAME']

	  # Definisce l'URL dell'Identity Server:
	  # config.issuer = "https://www.example.org"
	  config.issuer = ENV['PUA_ISSUER']

	  # Definisce l'URL del Relying Party:
	  # config.relying_party = "https://www.mydomain.org"
	  config.relying_party = ENV['PUA_RELYING_PARTY']

	  # Attributo per matchare l'utente
	  config.uid_field = :nickname # Default value: sub

	  # Definisce lo scope da utilizzare:
	  config.scope =  %i[openid email profile providername providersubject] # Default: [] Es: %i[openid profile email]

	  # Definisce l'app ID
	  config.app_id = ENV['PUA_APP_ID']

	  # Definisce l'app secret
	  config.app_secret= ENV['PUA_APP_SECRET']

	  # Mappatura delle chiavi che verranno salvate sul DB nell'autorizzazione
	  config.attributes = {
		name: 'given_name',
		surname: 'family_name',
		fiscal_code: 'nickname',
		email: 'email',
		providername: 'providername',
		providersubject: 'providersubject'
	  }
	  #
	  # I campi da escludere dall'export nei processi a causa della policy GDPR.
	  # Deve contenere un'array di chiavi presenti in attributes.
	  # Se l'array è vuoto saranno inseriti tutti quelli disponibili
	  # config.export_exclude_attributes = [
	  #   :name, :surname, :fiscal_code, :gender, :birthdate, :phone_number, :email, :address
	  # ]
	  #
	end
end