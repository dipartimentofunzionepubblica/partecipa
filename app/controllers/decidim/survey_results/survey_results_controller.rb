# frozen_string_literal: true

#
# Copyright (C) 2025 Formez PA
#
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# Modificata visibilità sul metodo survey da private a protected per far sì che app/overrides/decidim/forms/questionnaires/questionnaire_show.rb possa avere un controllo
# sulla verifica che un questionario sia chiuso, allo scopo di mostrare o meno il link ai risultati del questionario 


module Decidim
  module SurveyResults
    class SurveyResultsController < ApplicationController
      include Decidim::ApplicationHelper
      include Decidim::SurveyResults::SurveyResultsHelper

      def show
        @full_questionnaire = FullQuestionnaire.new(questionnaire)
      end

      def current_component
        @current_component ||= Decidim::Component.find(params[:component_id])
      end

      def current_participatory_space
        @current_participatory_space ||= current_component.participatory_space
      end

      protected
	  
      def survey
         @survey ||= ::Decidim::Surveys::Survey.find_by(component: current_component)
      end 
	  
      def questionnaire
         @questionnaire ||= ::Decidim::Forms::Questionnaire.find_by(questionnaire_for: survey)
      end
    end
  end
end