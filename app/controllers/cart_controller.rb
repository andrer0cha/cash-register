# frozen_string_literal: true

class CartController < ApplicationController
  before do
    handle_current_user!
  end

  get '/' do # GET /cart/
    format_response(
      status: 200,
      body: formated_response
    )
  end

  patch '/add_product' do
    ::AddToCart.new(
      current_user:,
      product: Product.find(@request_body['product_id']),
      qty_to_add: @request_body['qty_to_add']
    ).call

    format_response(
      status: 200,
      body: formated_response
    )
  end

  delete '/remove_product' do
    ::DeleteFromCart.new(
      current_user:,
      product: Product.find(@request_body['product_id']),
      qty_to_delete: @request_body['qty_to_delete']
    ).call
  end

  delete '/clean_cart' do
    current_user.cart.carts_products.destroy_all

    format_response(
      status: 200,
      body: formated_response
    )
  end

  private

  def current_user_cart_products
    current_user.cart.carts_products || []
  end

  def cart_products_grouped
    return [] unless current_user_cart_products.any?

    current_user_cart_products.group_by do |p|
      p.product.name
    end
  end

  def cart_products_grouped_transformed
    return [] unless current_user_cart_products.any?

    cart_products_grouped.transform_values do |v|
      { qty: v.count, value: v.sum(&:unit_price).to_f / 100.0 }
    end
  end

  def formated_response
    [
      items: cart_products_grouped_transformed,
      total: current_user_cart_products&.sum(&:unit_price).to_f / 100.0
    ]
  end
end
