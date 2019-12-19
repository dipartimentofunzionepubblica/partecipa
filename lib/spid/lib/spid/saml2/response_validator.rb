# frozen_string_literal: true

require "xmldsig"
require "time"

module Spid
  module Saml2
	# rubocop:disable Metrics/ClassLength
	class ResponseValidator # :nodoc:
	  attr_reader :response
	  attr_reader :settings
	  attr_reader :errors
	  attr_reader :request_uuid
	  attr_reader :authn_issue_instant
	  attr_reader :acs_url
	  attr_reader :authn_context

	  def initialize(response:, settings:, request_uuid:, authn_issue_instant:, acs_url:, authn_context:)
		@response = response
		@settings = settings
		@request_uuid = request_uuid
		@authn_issue_instant = authn_issue_instant
		@acs_url = acs_url
		@authn_context = authn_context
		@errors = {}

		Spid.configuration.logger.info "============================================" + response.saml_message.to_s + "============================================"
	  end

	  def call
		return false unless success?
		[
		  response_id, version, issue_instant, issuer_format, 
		  assertion_version, assertion_issue_instant, assertion_id, assertion_nameid, assertion_nameid_format, assertion_nameid_namequalifier, 
		  assertion_subjectconfirmation, assertion_subjectconfirmation_method, assertion_subjectconfirmationdata_recipient, assertion_subjectconfirmationdata_inresponseto, 
		  assertion_subjectconfirmationdata_notonorafter, assertion_conditions, assertion_conditions_notbefore, assertion_authnstatement, assertion_authnstatement_authncontext,
		  assertion_authnstatement_authncontext_authncontextclassref, assertion_attributestatement, 
		  matches_request_uuid, issuer, assertion_issuer, certificate, destination, conditions, audience, signature
		].all?
	  end

	  def response_id
		return true if !response.element_from_xpath(response.saml_and_saml2("/samlp:Response/@ID")).blank?
		@errors["response_id"] = 
		  "Errore Spid 1: il parametro Response ID è un parametro necessario"
		false
	  end
	  
	  def version
		return true if response.element_from_xpath(response.saml_and_saml2("/samlp:Response/@Version")) == Spid::SAML_VERSION 
		@errors["version"] = 
		  begin
			"Errore Spid 2: la Response Version attesa è '#{Spid::SAML_VERSION}'"
		  end
		false
	  end
	  
	  def issue_instant
		curr_issue_instant = response.element_from_xpath(response.saml_and_saml2("/samlp:Response/@IssueInstant"))
		return true if !curr_issue_instant.blank? && 
			curr_issue_instant == Time.parse(curr_issue_instant).iso8601(3) && 
				Time.parse(curr_issue_instant).iso8601 >= Time.parse(@authn_issue_instant).iso8601
		@errors["issue_instant"] = 
		  begin
			"Errore Spid 3: il parametro Response IssueInstant '#{curr_issue_instant}' è un parametro necessario atteso come un date iso8601 successivo a AuthnRequest IssueInstant '#{@authn_issue_instant}'"
		  end
		false
	  end
	  
	  def issuer_format
		format_element = response.document.elements[response.saml_and_saml2("boolean(/samlp:Response/saml:Issuer[@Format='#{Spid::SAML_ISSUER_FORMAT}'])")]
		assertion_format_element = response.document.elements[response.saml_and_saml2("boolean(/samlp:Response/saml:Assertion/saml:Issuer[@Format='#{Spid::SAML_ISSUER_FORMAT}'])")]
		
		Spid.configuration.logger.info "============================================> format_element = " + format_element.to_s
		Spid.configuration.logger.info "============================================> assertion_format_element = " + assertion_format_element.to_s
		
		return true #if format_element && assertion_format_element
		@errors["issuer_format"] =
		  begin
			"Errore Spid 4: il parametro Response Issuer Format e Assertion Issuer Format sono attesi con lo stesso valore '#{Spid::SAML_ISSUER_FORMAT}'"
		  end
		false
	  end
	  
	  def assertion_version
	  
		Spid.configuration.logger.info "============================================> assertion_version = " + response.document.elements[response.saml_and_saml2("/samlp:Response/saml:Assertion/@Version")].value 
	  
		return true if response.document.elements[response.saml_and_saml2("/samlp:Response/saml:Assertion/@Version")].value == Spid::SAML_VERSION
		@errors["assertion_version"] = 
		  begin
			"Errore Spid 5: il parametro Assertion Version è atteso col valore'#{Spid::SAML_VERSION}'"
		  end
		false
	  end
	  
	  def assertion_issue_instant
		curr_assertion_issue_instant = response.element_from_xpath(response.saml_and_saml2("/samlp:Response/saml:Assertion/@IssueInstant"))
		return true if !curr_assertion_issue_instant.blank? && 
			!@authn_issue_instant.blank? && 
				curr_assertion_issue_instant == Time.parse(curr_assertion_issue_instant).iso8601(3).to_s && 
					Time.parse(curr_assertion_issue_instant).iso8601 >= Time.parse(@authn_issue_instant).iso8601
		@errors["assertion_issue_instant"] = 
		  begin
			"Errore Spid 6: il parametro Assertion IssueInstant '#{curr_assertion_issue_instant}' è atteso come un date iso8601 successivo a AuthnRequest IssueInstant '#{@authn_issue_instant}'"
		  end
		false
	  end
	  
	  def assertion_id
		return true if !response.element_from_xpath(response.saml_and_saml2("/samlp:Response/saml:Assertion/@ID")).blank?
		@errors["assertion_id"] = 
		  "Errore Spid 7: il parametro Assertion ID è un parametro necessario"
		false
	  end
	  
	  def assertion_nameid 
		return true if !response.element_from_xpath(response.saml_and_saml2("/samlp:Response/saml:Assertion//saml:NameID/text()")).blank?
		@errors["assertion_nameid"] = 
		   "Errore Spid 8: il parametro Assertion NameID è un parametro necessario"
		false
	  end
	  
	  def assertion_nameid_format
		format = response.element_from_xpath(response.saml_and_saml2("/samlp:Response/saml:Assertion//saml:NameID/@Format"))
		return true if !format.blank? && format == Spid::SAML_NAMEID_FORMAT
		@errors["assertion_nameid_format"] =
			"Errore Spid 9: il parametro Assertion NameID Format è atteso con lo stesso valore '#{Spid::SAML_NAMEID_FORMAT}'"
		false
	  end
	  
	  def assertion_nameid_namequalifier
		namequalifier = response.element_from_xpath(response.saml_and_saml2("/samlp:Response/saml:Assertion//saml:NameID/@NameQualifier"))
		return true if !namequalifier.blank? 
		@errors["assertion_nameid_namequalifier"] =
			"Errore Spid 10: il parametro Assertion NameID NameQualifier è un parametro necessario"
		false
	  end
	  
	  def assertion_subjectconfirmation
		return true if !response.document.elements[response.saml_and_saml2("/samlp:Response/saml:Assertion//saml:SubjectConfirmation//saml:SubjectConfirmationData")].blank?
		@errors["assertion_subjectconfirmation"] =
			"Errore Spid 11: il parametro Assertion SubjectConfirmationData è un parametro necessario"
		false
	  end
	  
	  def assertion_subjectconfirmation_method
		method = response.element_from_xpath(response.saml_and_saml2("/samlp:Response/saml:Assertion//saml:SubjectConfirmation/@Method"))
		return true if !method.blank? && method == Spid::SAML_SUBJECTCONFIRMATION_METHOD
		@errors["assertion_subjectconfirmation_method"] =
			begin
				"Errore Spid 12: il parametro Assertion SubjectConfirmation Method è atteso con lo stesso valore '#{Spid::SAML_SUBJECTCONFIRMATION_METHOD}'"
			end
		false
	  end

	  def assertion_subjectconfirmationdata_recipient
		recipient = response.element_from_xpath(response.saml_and_saml2("/samlp:Response/saml:Assertion//saml:SubjectConfirmation//saml:SubjectConfirmationData/@Recipient"))
		return true if !recipient.blank? && recipient == acs_url
		@errors["assertion_subjectconfirmationdata_recipient"] =
			begin
				"Errore Spid 13: il parametro Assertion SubjectConfirmationData Recipient '#{recipient}' è un parametro necessario atteso con lo stesso valore di AssertionConsumerServiceUrl '#{acs_url}'"
			end
		false
	  end
	  
	  def assertion_subjectconfirmationdata_inresponseto
		inresponseto = response.element_from_xpath(response.saml_and_saml2("/samlp:Response/saml:Assertion//saml:SubjectConfirmation//saml:SubjectConfirmationData/@InResponseTo"))
		return true if !inresponseto.blank? && inresponseto == request_uuid
		@errors["assertion_subjectconfirmationdata_inresponseto"] =
			"Errore Spid 14: il parametro Assertion SubjectConfirmationData InResponseTo è un parametro necessario e deve essere uguale al parametro Request UUID"
		false
	  end
	  
	  def assertion_subjectconfirmationdata_notonorafter
		notonorafter = response.element_from_xpath(response.saml_and_saml2("/samlp:Response/saml:Assertion//saml:SubjectConfirmation//saml:SubjectConfirmationData/@NotOnOrAfter"))
		curr_assertion_issue_instant = response.element_from_xpath(response.saml_and_saml2("/samlp:Response/saml:Assertion/@IssueInstant"))
		return true if !notonorafter.blank? && !curr_assertion_issue_instant.blank? &&
			notonorafter == Time.parse(notonorafter).iso8601(3).to_s && 
				Time.parse(notonorafter).iso8601 > Time.parse(curr_assertion_issue_instant).iso8601
		@errors["assertion_subjectconfirmationdata_notonorafter"] =
			begin
				"Errore Spid 15: il parametro Assertion SubjectConfirmationData NotOnOrAfter '#{notonorafter}' è un parametro necessario, atteso come un date iso8601 successivo a Assertion IssueInstant '#{curr_assertion_issue_instant}'"
			end
		false
	  end
	  
	  def assertion_conditions
		conditions_saml = response.document.elements["boolean(/samlp:Response/saml:Assertion//saml:Conditions/*)"]
		conditions_saml2 = response.document.elements["boolean(/saml2p:Response/saml2:Assertion//saml2:Conditions/*)"]
		
		Spid.configuration.logger.info "============================================> assertion_conditions conditions_saml = " + conditions_saml.to_s
		Spid.configuration.logger.info "============================================> assertion_conditions conditions_saml2 = " + conditions_saml2.to_s
		
		return true if conditions_saml || conditions_saml2
		@errors["assertion_conditions"] =
			begin
				"Errore Spid 16: il parametro Assertion Conditions è un parametro necessario"
			end
		false
	  end
	  
	  def assertion_conditions_notbefore
		notbefore = response.element_from_xpath(response.saml_and_saml2("/samlp:Response/saml:Assertion//saml:Conditions/@NotBefore"))
		return true if !notbefore.blank? #&& 
			notbefore == Time.parse(notbefore).iso8601(3).to_s 
		@errors["assertion_conditions_notbefore"] =
			begin
				"Errore Spid 17: il parametro Assertion SubjectConfirmationData NotBefore '#{notbefore}' è un parametro necessario, atteso come un date iso8601"
			end
		false
	  end
		
	  def assertion_authnstatement
		authnstatement_saml = response.document.elements["boolean(/samlp:Response/saml:Assertion//saml:AuthnStatement/*)"]
		authnstatement_saml2 = response.document.elements["boolean(/saml2p:Response/saml2:Assertion//saml2:AuthnStatement/*)"]
		return true if authnstatement_saml || authnstatement_saml2
		@errors["assertion_authnstatement"] =
			"Errore Spid 18: il parametro Assertion AuthnStatement è un parametro necessario"
		false
	  end

	  def assertion_authnstatement_authncontext
		authnstatement_authncontext_saml = response.document.elements["boolean(/samlp:Response/saml:Assertion/saml:AuthnStatement/saml:AuthnContext/*)"]
		authnstatement_authncontext_saml2 = response.document.elements["boolean(/saml2p:Response/saml2:Assertion/saml2:AuthnStatement/saml2:AuthnContext/*)"]
		return true if authnstatement_authncontext_saml || authnstatement_authncontext_saml2
		@errors["assertion_authnstatement_authcontext"] =
			"Errore Spid 19: il parametro Assertion AuthnStatement AuthContext è un parametro necessario"
		false
	  end
	  
	  def assertion_authnstatement_authncontext_authncontextclassref
		assertion_authnstatement_authncontext_authncontextclassref = response.element_from_xpath(response.saml_and_saml2("/samlp:Response/saml:Assertion//saml:AuthnStatement/saml:AuthnContext/saml:AuthnContextClassRef/text()"))
		return true if !assertion_authnstatement_authncontext_authncontextclassref.blank? && 
			Spid::AUTHN_CONTEXTS.include?(assertion_authnstatement_authncontext_authncontextclassref) && 
				assertion_authnstatement_authncontext_authncontextclassref == authn_context
		@errors["assertion_authnstatement_authncontext_authncontextclassref"] =
			begin
				"Errore Spid 20: il parametro Assertion AuthnStatement 
					AuthContext AuthnContextClassRef è un parametro necessario, 
					atteso con uno di questi valori '#{Spid::AUTHN_CONTEXTS.to_sentence}' e deve avere lo stesso valore passato dalla Request" 
			end
		false
	  end
	  
	  def assertion_attributestatement
		assertion_attributestatement = response.document.elements[response.saml_and_saml2("/samlp:Response/saml:Assertion//saml:AttributeStatement/*")]
		return true if !assertion_attributestatement.blank? 
		@errors["assertion_attributestatement"] =
			"Errore Spid 21: il parametro Assertion AttributeStatement è un parametro necessario, e atteso con all'interno almeno un Attribute" 
		false
	  end
	  
	  def matches_request_uuid
		return true if response.in_response_to == request_uuid
		@errors["request_uuid_mismatch"] =
		  "Errore Spid 22: il parametro Request uuid non appartiene alla sessione corrente"
		false
	  end

	  def success?
		return true if response.status_code == Spid::SUCCESS_CODE
		status_message = response.document.elements[response.saml_and_saml2("/samlp:Response/saml:Status/saml:StatusMessage/text()")]
		@errors["authentication"] = 
			begin
			"Errore Spid: autenticazione non andata a buon fine: status_message: '#{status_message}', status_code: '#{response.status_code}'"
			end
		false
	  end
	  
	  def issuer
		return true if response.issuer == settings.idp_entity_id
		@errors["issuer"] =
		  begin
			"Errore Spid 24: il parametro Response Issuer è '#{response.issuer}'" \
			" ma è atteso '#{settings.idp_entity_id}'"
		  end
		false
	  end

	  def assertion_issuer
		return true if response.assertion_issuer == settings.idp_entity_id
		@errors["assertion_issuer"] =
		  begin
			"Errore Spid 25: il parametro Response Assertion Issuer è '#{response.assertion_issuer}'" \
			" ma è atteso '#{settings.idp_entity_id}'"
		  end
		false
	  end

	  def certificate
		if response.certificate.to_der == settings.idp_certificate.to_der
		  return true
		end

		@errors["certificate"] = "Errore Spid 26: errore di mancata corrispondenza del certificato"
		false
	  end

	  def destination
		return true if response.destination == settings.sp_acs_url
		return true if response.destination == settings.sp_entity_id

		@errors["destination"] =
		  begin
			"Errore Spid 27: il parametro Response Destination é '#{response.destination}'" \
			" ma è atteso '#{settings.sp_acs_url}'"
		  end
		false
	  end

	  def conditions
		time = Time.now.utc.iso8601

		if response.conditions_not_before <= time &&
		   response.conditions_not_on_or_after > time

		  return true
		end

		@errors["conditions"] = "Errore Spid 28: la Response è scaduta"
		false
	  end

	  def audience
		return true if response.audience == settings.sp_entity_id
		@errors["audience"] =
		  begin
			"Errore Spid 29: il parametro Response Audience é '#{response.audience}'" \
			" ma è atteso '#{settings.sp_entity_id}'"
		  end
		false
	  end

	  def signature
		signed_document = Xmldsig::SignedDocument.new(response.saml_message)
		return true if signed_document.validate(response.certificate)
		@errors["signature"] = "Errore Spid 30: errore di mancata corrispondenza della firma"
		false
	  end

	  def subject_recipient
		return true if response.subject_recipient == settings.sp_acs_url
	  end

	  def subject_in_response_to
		return true if response.subject_in_response_to == request_uuid
	  end

	  def subject_not_on_or_after
		time = Time.now.utc.iso8601
		return true if response.subject_not_on_or_after > time
	  end
	end
	# rubocop:enable Metrics/ClassLength
  end
end