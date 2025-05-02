$posthog = PostHog::Client.new(
  api_key: 'phc_TOrEF0a6Sd7duFHYpwKfcYqfz44r5K9dvQUR3WQw40H',
  host: "https://eu.i.posthog.com",
  on_error: Proc.new { |status, msg| print msg }
)
