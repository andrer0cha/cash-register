# frozen_string_literal: true

class AddToCart
  class Error < StandardError; end
  class ProductNotFound < Error; end

  extend Dry::Initializer

  option :current_user
  option :product_id

  def call
    current_user.cart.products << given_product

    current_user.cart.products
  rescue ActiveRecord::RecordNotFound
    raise ProductNotFound, 'Product not found for given id.'
  end

  private

  def given_product
    @given_product ||= Product.find(product_id)
  end
end
