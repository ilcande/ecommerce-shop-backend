# spec/rails_helper.rb

require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'shoulda/matchers'
require 'factory_bot_rails'
require 'faker'

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

# Checks for pending migrations and applies them before tests are run.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  config.fixture_paths = [
    Rails.root.join('spec/fixtures')
  ]

  # Use FactoryBot methods without explicitly calling FactoryBot.
  config.include FactoryBot::Syntax::Methods

  # Use transactional fixtures by default.
  config.use_transactional_fixtures = true

  # Automatically infer the spec type from the file location.
  config.infer_spec_type_from_file_location!

  # Filter out Rails backtrace.
  config.filter_rails_from_backtrace!
end
