# frozen_string_literal: true

ENV['RACK_ENV'] ||= 'test'

require_relative '../config/app'
require_all 'spec/factories/*.rb'

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include FactoryBot::Syntax::Methods

  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec

    with.library :active_record
    with.library :active_model
  end
end
