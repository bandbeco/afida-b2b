# frozen_string_literal: true

require 'posthog'

$posthog = PostHog::Client.new(
  api_key: 'phc_TOrEF0a6Sd7duFHYpwKfcYqfz44r5K9dvQUR3WQw40H',
  host: 'https://eu.i.posthog.com',
  on_error: proc { |_status, msg| print msg }
)
