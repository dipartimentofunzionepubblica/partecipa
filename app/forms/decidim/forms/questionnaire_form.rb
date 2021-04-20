# frozen_string_literal: true

# Copyright (C) 2020 Formez PA
#
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# frozen_string_literal: true

module Decidim
  module Forms
    # This class holds a Form to answer a questionnaire from Decidim's public page.
    class QuestionnaireForm < Decidim::Form
      attribute :responses, Array[AnswerForm]
      attribute :user_group_id, Integer

      attribute :tos_agreement, Boolean

      validates :tos_agreement, allow_nil: false, acceptance: true
      validate :session_token_in_context

      # Private: Create the responses from the questionnaire questions
      #
      # Returns nothing.
      def map_model(model)
        self.responses = model.questions.map do |question|
          AnswerForm.from_model(Decidim::Forms::Answer.new(question: question))
        end
      end

      def session_token_in_context
        return if context&.session_token

        errors.add(:tos_agreement, I18n.t('activemodel.errors.models.questionnaire.request_invalid'))
      end
    end
  end
end
