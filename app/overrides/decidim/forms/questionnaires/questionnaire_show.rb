# frozen_string_literal: true

#
# Copyright (C) 2025 Formez PA
#
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# Modificata visualizzare il link ai risultati del questionario solo a questionario chiuso e a flag enable_results sul componente flaggato a true

Deface::Override.new(virtual_path: "decidim/forms/questionnaires/show",
  name: "add_button_to_questionnaire_answers",
  original: "f2fe5ee7066f632fb4a930c922c680ddfbdc1520",
  insert_after: "div.card",
  text: "

    <%= link_to I18n.t('survey_results.questionnaire_show.see_results'), decidim_survey_results.survey_results_path(component_id: current_component.id) if current_component.settings.enable_results && !@survey&.open? %>
    
  ")
