# frozen_string_literal: true

Deface::Override.new(virtual_path: "decidim/forms/questionnaires/show",
  name: "add_button_to_questionnaire_answers",
  original: "f2fe5ee7066f632fb4a930c922c680ddfbdc1520",
  insert_after: "div.card",
  text: "
    <%= link_to I18n.t('survey_results.questionnaire_show.see_results'), decidim_survey_results.survey_results_path(component_id: current_component.id) %>
  ")
