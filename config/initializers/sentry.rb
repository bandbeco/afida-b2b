# frozen_string_literal: true

unless Rails.env.test?
  Sentry.init do |config|
    config.dsn = "https://fe6c1eb5c83ef136c3070264f6caf37a@o4510354394841088.ingest.de.sentry.io/4510356970274896"
    config.breadcrumbs_logger = [ :active_support_logger, :http_logger ]

    # Add data like request headers and IP for users,
    # see https://docs.sentry.io/platforms/ruby/data-management/data-collected/ for more info
    config.send_default_pii = true
  end
end
