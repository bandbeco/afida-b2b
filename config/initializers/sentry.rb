# frozen_string_literal: true

Sentry.init do |config|
  config.dsn = ENV['SENTRY_DSN']
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]

  # Set traces_sample_rate to 1.0 to capture 100%
  # of transactions for tracing.
  # We recommend adjusting this value in production.
  config.traces_sample_rate = ENV.fetch('SENTRY_TRACES_SAMPLE_RATE', 0.1).to_f

  # Set profiles_sample_rate to profile 100%
  # of sampled transactions.
  # We recommend adjusting this value in production.
  config.profiles_sample_rate = ENV.fetch('SENTRY_PROFILES_SAMPLE_RATE', 0.1).to_f

  # Filter out sensitive parameters
  config.send_default_pii = false

  # Set the environment
  config.environment = Rails.env

  # Enable async error reporting
  config.background_worker_threads = 5

  # Only send errors in production by default
  config.enabled_environments = %w[production staging]
end
