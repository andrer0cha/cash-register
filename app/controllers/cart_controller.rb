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
      current_user:,
      product_id: @request_body['product_id']
    ).call
  end

  delete '/remove_product' do
    ::DeleteFromCart.new(
      current_user:,
      product_id: @request_body['product_id']
    ).call
  end

  delete '/clean_cart' do
    current_user.cart.carts_products.destroy_all

    current_user_cart_products
  end

  private

  def current_user_cart_products
    current_user.cart.products || []
  end
end
