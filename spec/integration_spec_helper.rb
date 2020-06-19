# Make all rspec configuration changes to this file.
# Leave automatically generated configuration files untouched to facilitate gem upgrades.

ENV["RAILS_ENV"] ||= "test"

require File.expand_path("../dummy/config/environment.rb", __FILE__)

require "rspec/rails"
require "active_record"
require_relative "./helpers/db_helpers"

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].sort.each { |f| require f }

RSpec.configure do |config|
  # Uncomment this line to see full backtraces for spec failures
  # config.backtrace_exclusion_patterns = []

  config.profile_examples = 0
  config.use_transactional_fixtures = true

  # Increase characters displayed when exceptions fail (the RSpec default is 200 characters).
  config.expect_with(:rspec) do |c|
    c.max_formatted_output_length = 1_000_000
  end
end

RSpec.configure do |config|
  config.include DbHelpers
end
