# frozen_string_literal: true

ENV['RACK_ENV'] ||= 'test'

require_relative '../config/app'

RSpec.configure do |config|
  config.include Rack::Test::Methods

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
