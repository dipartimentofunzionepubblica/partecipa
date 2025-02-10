# frozen_string_literal: true

#
# Copyright (C) 2025 Formez PA
#
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# Modificato per risolvere un problema sul metodo map_model, self.conclusions


module Decidim
  module Debates
    # This class holds a Form to close debates from Decidim's public views.
    class CloseDebateForm < Decidim::Form
      mimic :debate

      attribute :conclusions, Decidim::Attributes::CleanString
      attribute :debate, Debate

      validates :debate, presence: true
      validates :conclusions, presence: true, length: { minimum: 10, maximum: 10_000 }
      validate :user_can_close_debate

      def closed_at
        debate&.closed_at || Time.current
      end

      def map_model(debate)
        super
        self.debate = debate

        # Debates can be translated in different languages from the admin but
        # the public form doesn't allow it. When a user closes a debate the
        # user locale is taken as the text locale.
        
        # Inserito metodo try perché la chiamata del metodo values generava errore
        self.conclusions = debate&.conclusions&.try(:values)&.try(:first)
      end

      private

      def user_can_close_debate
        return if !debate || !debate.respond_to?(:closeable_by?)

        errors.add(:debate, :invalid) unless debate.closeable_by?(current_user)
      end
    end
  end
end

