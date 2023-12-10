# frozen_string_literal: true

class DeleteFromCart
  class Error < StandardError; end
  class ProductNotFound < Error; end
  class ProductNotInCart < Error; end

  extend Dry::Initializer

  option :current_user
  option :product
  option :qty_to_delete

  def call
    raise(ProductNotInCart, 'Product not found in cart.') unless product_in_cart?

    remove_given_product_from_cart!

    current_user_cart_products.reload
  rescue ActiveRecord::RecordNotFound
    raise ProductNotFound, 'Product not found for given id.'
  end

  private

  def product_in_cart?
    current_user_cart_products.include?(product)
  end

  def current_user_cart_products
    current_user.cart.products
  end

  def remove_given_product_from_cart!
    qty_to_delete.times do
      current_user.cart.carts_products.find_by(product_id: product.id)&.destroy
    end
  end
end
