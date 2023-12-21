# frozen_string_literal: true

# Copyright (C) 2023 Formez PA
#
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>
#
# Modificato per limitare a 120 caratteri la description del meeting nella card

module Decidim
  module Meetings
    # This cell renders the Medium (:m) meeting card
    # for an given instance of a Meeting
    class MeetingMCell < Decidim::CardMCell
      include MeetingCellsHelper

      def has_authors?
        true
      end

      def render_authorship
        cell "decidim/author", author_presenter_for(model.normalized_author)
      end

      def date
        render
      end

      def address
        decidim_html_escape(render)
      end

      def title
        present(model).title
      end

      def description
        present(model).description(strip_tags: true).truncate(120, separator: /\s/)
      end

      delegate :online_meeting?, to: :model

      private

      def spans_multiple_dates?
        start_date != end_date
      end

      def meeting_date
        return render(:multiple_dates) if spans_multiple_dates?

        render(:single_date)
      end

      def formatted_start_time
        model.start_time.strftime("%H:%M")
      end

      def formatted_end_time
        model.end_time.strftime("%H:%M")
      end

      def start_date
        model.start_time.to_date
      end

      def end_date
        model.end_time.to_date
      end

      def can_join?
        model.can_be_joined_by?(current_user)
      end

      def show_footer_actions?
        options[:show_footer_actions]
      end

      def statuses
        [:follow, :comments_count]
      end
    end
  end
end
