# frozen_string_literal: true

# SimpleCov must be loaded before any application code
require "simplecov"

# SimpleCov configuration for parallel tests
SimpleCov.start "rails" do
  enable_coverage :branch
  primary_coverage :line

  add_filter "/bin/"
  add_filter "/db/"
  add_filter "/spec/"
  add_filter "/test/"
  add_filter "/config/"
  add_filter "/vendor/"

  add_group "Models", "app/models"
  add_group "Controllers", "app/controllers"
  add_group "Helpers", "app/helpers"
  add_group "Mailers", "app/mailers"
  add_group "Jobs", "app/jobs"

  track_files "{app,lib}/**/*.rb"

  # Coverage thresholds (will fail if below)
  # minimum_coverage 90
  # minimum_coverage_by_file 80
end

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Disable parallel testing for SimpleCov to work correctly
    # Re-enable after coverage baseline is established if needed
    # parallelize(workers: :number_of_processors)
    parallelize(workers: 1)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end
