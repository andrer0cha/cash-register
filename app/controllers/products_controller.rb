# frozen_string_literal: true

class ProductsController < ApplicationController
  after do
    response.body = response.body.to_json unless response.body.is_a? String
  end

  get '/products' do
    Product.all
  end
end
