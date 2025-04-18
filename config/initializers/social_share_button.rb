# frozen_string_literal: true

# Further information on how to configure the SocialShareButton gem can be
# found here: https://github.com/huacnlee/social-share-button#configure
#
# Mofiicato per eliminare i bottoni social in relazione al bug https://github.com/decidim/decidim/issues/8956
SocialShareButton.configure do |config|
  config.allow_sites = %w(twitter facebook whatsapp_app whatsapp_web telegram)
end

