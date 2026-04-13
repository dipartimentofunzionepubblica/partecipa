# frozen_string_literal: true

# Copyright (C) 2025 Formez
#
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# Modificata per la gestione corretta della validazione, in caso di domanda a risposta obbligatoria la mancata risposta produceva il mancato caricamento delle risposte nel caso delle domande a matrice


module Decidim
    module Forms
    # The data store for a Question in the Decidim::Forms component.
      class Question < Forms::ApplicationRecord
        include Decidim::TranslatableResource
			
			QUESTION_TYPES = %w(short_answer long_answer single_option multiple_option sorting files matrix_single matrix_multiple).freeze
			SEPARATOR_TYPE = "separator"
			TITLE_AND_DESCRIPTION_TYPE = "title_and_description"
			TYPES = (QUESTION_TYPES + [SEPARATOR_TYPE, TITLE_AND_DESCRIPTION_TYPE]).freeze
			
			has_many :display_conditions_for_other_questions,
			class_name: "DisplayCondition",
			foreign_key: "decidim_condition_question_id",
			dependent: :destroy,
			inverse_of: :condition_question
		end 
	end	   
end

# frozen_string_literal: true

module Decidim
  module Forms
    # The data store for a Question in the Decidim::Forms component.
    class Question < Forms::ApplicationRecord
      include Decidim::TranslatableResource

      QUESTION_TYPES = %w(short_answer long_answer single_option multiple_option sorting files matrix_single matrix_multiple).freeze
      SEPARATOR_TYPE = "separator"
      TITLE_AND_DESCRIPTION_TYPE = "title_and_description"
      TYPES = (QUESTION_TYPES + [SEPARATOR_TYPE, TITLE_AND_DESCRIPTION_TYPE]).freeze

      translatable_fields :body, :description

      belongs_to :questionnaire, class_name: "Questionnaire", foreign_key: "decidim_questionnaire_id"

      has_many :matrix_rows,
               class_name: "QuestionMatrixRow",
               foreign_key: "decidim_question_id",
               dependent: :destroy,
               inverse_of: :question

      has_many :answer_options,
               class_name: "AnswerOption",
               foreign_key: "decidim_question_id",
               dependent: :destroy,
               inverse_of: :question

      # Conditions to display this question in questionnaire
      has_many :display_conditions,
               class_name: "DisplayCondition",
               foreign_key: "decidim_question_id",
               dependent: :destroy,
               inverse_of: :question

      # Conditions to display other questions based on the value of this question's answer
      #has_many :display_conditions_for_other_questions,
      #         class_name: "DisplayCondition",
      #         foreign_key: "decidim_condition_question_id",
      #         dependent: :destroy,
      #         inverse_of: :question
	  
	  # MODIFICATO PER GESTIRE LA VISUALIZZAZIONE DELLE DOMANDE CONDIZIONALI IN CASO DI VALIDAZIONE FALLITA
      # Conditions to display other questions based on the value of this question's answer
	  has_many :display_conditions_for_other_questions,
			class_name: "DisplayCondition",
			foreign_key: "decidim_condition_question_id",
			dependent: :destroy,
			inverse_of: :condition_question
	  
      # Questions which have display conditions based on the value of this question's answer
      has_many :conditioned_questions,
               through: :display_conditions_for_other_questions,
               foreign_key: "decidim_condition_question_id",
               class_name: "Question"

      validates :question_type, inclusion: { in: TYPES }

      scope :not_separator, -> { where.not(question_type: SEPARATOR_TYPE) }
      scope :not_title_and_description, -> { where.not(question_type: TITLE_AND_DESCRIPTION_TYPE) }

      scope :with_body, -> { where(question_type: %w(short_answer long_answer)) }
      scope :with_choices, -> { where.not(question_type: %w(short_answer long_answer)) }

      scope :conditioned, -> { includes(:display_conditions).where.not(decidim_forms_display_conditions: { id: nil }) }
      scope :not_conditioned, -> { includes(:display_conditions).where(decidim_forms_display_conditions: { id: nil }) }

      def matrix?
        %w(matrix_single matrix_multiple).include?(question_type)
      end

      def multiple_choice?
        %w(single_option multiple_option sorting matrix_single matrix_multiple).include?(question_type)
      end

      def mandatory_body?
        mandatory? && !multiple_choice? && !has_attachments?
      end

      def mandatory_choices?
        mandatory? && multiple_choice? && !has_attachments?
      end

      def number_of_options
        answer_options.size
      end

      def translated_body
        Decidim::Forms::QuestionPresenter.new(self).translated_body
      end

      def separator?
        question_type.to_s == SEPARATOR_TYPE
      end

      def title_and_description?
        question_type.to_s == TITLE_AND_DESCRIPTION_TYPE
      end

      def has_attachments?
        question_type.to_s == "files"
      end

      def answers_count
        questionnaire.answers.where(question: self).count
      end
    end
  end
end
