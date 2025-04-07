# frozen_string_literal: true

Sentry.init do |config|
  config.dsn = 'https://584a10c5c2c506f15c3db76cd0092133@o4508844991053824.ingest.de.sentry.io/4509026784116816'
  config.breadcrumbs_logger = %i[active_support_logger http_logger]

  # Add data like request headers and IP for users,
  # see https://docs.sentry.io/platforms/ruby/data-management/data-collected/ for more info
  config.send_default_pii = true
end
