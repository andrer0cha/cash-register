# frozen_string_literal: true

class DeleteFromCart
  class Error < StandardError; end
  class ProductNotFound < Error; end
  class ProductNotInCart < Error; end

  extend Dry::Initializer

  option :current_user
  option :product_id

  def call
    raise(ProductNotInCart, 'Product not found in cart.') unless product_in_cart?

    remove_given_product_from_cart!

    current_user_cart_products.reload
  rescue ActiveRecord::RecordNotFound
    raise ProductNotFound, 'Product not found for given id.'
  end

  private

  def product_in_cart?
    current_user_cart_products.include?(given_product)
  end

  def current_user_cart_products
    current_user.cart.products
  end

  def given_product
    @given_product ||= Product.find(product_id)
  end

  def remove_given_product_from_cart!
    if cart_product_record.units >= 2
      cart_product_record.units -= 1
      cart_product_record.save!
    else
      cart_product_record.destroy
    end
  end

  def cart_product_record
    @cart_product_record ||= CartsProduct.find_or_initialize_by(
      cart_id: current_user.cart.id,
      product_id:
    )
  end
end
