# frozen_string_literal: true

class ApplicationController < Sinatra::Base
  set :default_content_type, :json

  after do
    response.body = response.body.to_json unless response.body.is_a? String
  end

  def current_user
    User.find_by(
      first_name: 'Current',
      last_name: 'User',
      email: 'current.user@example.com'
    )
  end

  private

  def format_response(body:, status:)
    response.body = body
    response.status = status

    response
  end
end
