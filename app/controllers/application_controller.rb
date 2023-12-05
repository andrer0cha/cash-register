# frozen_string_literal: true

class ApplicationController < Sinatra::Base
  class Error < StandardError; end
  class MissingCurrentUser < Error; end

  set :default_content_type, :json

  before do
    request.body.rewind
    unparsed_body = request.body.read

    @request_body = JSON.parse(unparsed_body) unless unparsed_body.empty?
  end

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

  def handle_current_user!
    raise(MissingCurrentUser, 'Current User not found.') unless current_user.present?
  end
end
