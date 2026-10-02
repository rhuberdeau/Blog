require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'capybara/rspec'

Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.include FactoryBot::Syntax::Methods
  config.include ActiveSupport::Testing::TimeHelpers
  config.before { Rails.cache.clear }

  # The AI assistant never calls Anthropic from tests (Ai::Client refuses to).
  config.before(:suite) { Ai::Client.fake! }

  # Start from empty tables. `db:prepare` seeds every database it creates,
  # including the test one, and examples here count rows.
  config.before(:suite) do
    ActiveRecord::Base.connection.truncate_tables(*ActiveRecord::Base.connection.tables - %w[schema_migrations ar_internal_metadata])
  end
end
