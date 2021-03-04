ENV['RACK_ENV'] = 'test'
require 'rspec'
require 'rack/test'
require 'database_cleaner/active_record'
require "./config/environment"
require './spec/support/request_helpers.rb'

def app
  AdsController
end

include RequestHelpers


FactoryBot.definition_file_paths = %w{./factories ./test/factories ./spec/factories}
FactoryBot.find_definitions


RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include FactoryBot::Syntax::Methods

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end 
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end 
  config.filter_run :focus
  config.run_all_when_everything_filtered = true
  config.disable_monkey_patching!
  config.warnings = true
  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end 
  config.profile_examples = 10
  config.order = :random
  Kernel.srand config.seed

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:all) do
    DatabaseCleaner.start
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning { example.run }
  end

  config.after(:all) do
    DatabaseCleaner.clean
  end
end