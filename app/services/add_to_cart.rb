# frozen_string_literal: true

class AddToCart
  class Error < StandardError; end
  class ProductNotFound < Error; end

  extend Dry::Initializer

  option :current_user
  option :product
  option :qty_to_add

  def call
    add_to_cart!

    current_user.cart.products
  end

  private

  def add_to_cart!
    qty_to_add.times do |_index|
      CartsProduct.create!(
        cart_id: current_user.cart.id,
        product_id: product.id,
        unit_price: product.price
      )
    end
  end
end
