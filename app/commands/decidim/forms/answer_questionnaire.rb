#Copyright (C) 2020 Formez PA
#
#This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
#
#This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
#
#You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# frozen_string_literal: true

module Decidim
  module Forms
    # This command is executed when the user answers a Questionnaire.
    class AnswerQuestionnaire < Rectify::Command
      # Initializes a AnswerQuestionnaire Command.
      #
      # form - The form from which to get the data.
      # questionnaire - The current instance of the questionnaire to be answered.
      def initialize(form, current_user, questionnaire)
        @form = form
        @current_user = current_user
        @questionnaire = questionnaire
      end

      # Answers a questionnaire if it is valid
      #
      # Broadcasts :ok if successful, :invalid otherwise.
      def call
        return broadcast(:invalid) if @form.invalid?

        answer_questionnaire
        broadcast(:ok)
      end

      attr_reader :form

      private

      def answer_questionnaire
        Answer.transaction do
          form.responses.each do |form_answer|
            answer = Answer.new(
              user: @current_user,
              questionnaire: @questionnaire,
              question: form_answer.question,
              body: form_answer.body,
              session_token: form.context.session_token,
              ip_hash: form.context.ip_hash
            )

            form_answer.selected_choices.each do |choice|
              answer.choices.build(
                body: choice.body,
                custom_body: choice.custom_body,
                decidim_answer_option_id: choice.answer_option_id,
                position: choice.position
              )
            end

            answer.save!
          end
        end
      end
    end
  end
end