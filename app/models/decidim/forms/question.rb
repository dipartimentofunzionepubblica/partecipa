# frozen_string_literal: true

# Copyright (C) 2025 Formez
#
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# Modificata per inserire la funzione clearInputValues() per la gestione corretta dei valori in caso di cache delle risposte del questionario su Local Storage, v https://github.com/decidim/decidim/issues/13787


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