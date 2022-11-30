Deface::Override.new(virtual_path: "v0.25/layouts/decidim/_head", name: "insert-index-OPTIONS", insert_after: "meta[name='viewport']") do
  "
  <% if (defined?(user) && user && (current_page?(decidim.profile_activity_url(nickname: user.nickname)) || current_page?(decidim.profile_timeline_url(nickname: user.nickname))) && user.respond_to?(:can_user_index?) && !user.can_user_index?) ||
      (defined?(profile_holder) && profile_holder &&
        (current_page?(decidim.profile_following_url(nickname: profile_holder.nickname)) ||
          current_page?(decidim.profile_followers_url(nickname: profile_holder.nickname)) ||
          current_page?(decidim.profile_badges_url(nickname: profile_holder.nickname)) ||
          current_page?(decidim.profile_groups_url(nickname: profile_holder.nickname)) ||
          current_page?(decidim.profile_members_url(nickname: profile_holder.nickname))) && profile_holder.respond_to?(:can_user_index?) && !profile_holder.can_user_index?) %>
        <meta name='robots' content='noindex'>
  <% end %>
"
end
