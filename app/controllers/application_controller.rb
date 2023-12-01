# frozen_string_literal: true

class ApplicationController < Sinatra::Base
  configure do
    enable :logging
    use Rack::CommonLogger
  end
end
