# frozen_string_literal: true

class ProductsController < ApplicationController
  get '/' do # GET /products/
    format_response(
      body: Product.all,
      status: 200
    )
  end
end
