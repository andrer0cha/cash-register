# frozen_string_literal: true

class ApplicationController < Sinatra::Base
  set :default_content_type, :json

  get '/' do
    "Hello World"
  end
end
