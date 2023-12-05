# frozen_string_literal: true

class CartController < ApplicationController
  before do
    handle_current_user!
  end

  get '/' do # GET /cart/
    format_response(
      status: 200,
      body: current_user_cart_products
    )
  end

  patch '/add_product' do
    ::AddToCart.new(
      product_id: @request_body['product_id']
    ).call
  end

  private

  def current_user_cart_products
    current_user.cart.products || []
  end
end
