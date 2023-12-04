# frozen_string_literal: true

require_relative 'config/environment'

if ActiveRecord::Base.connection.migration_context.needs_migration?
  raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
end

run Rack::URLMap.new(
  '/products' => ProductsController,
  '/cart' => CartController
)
