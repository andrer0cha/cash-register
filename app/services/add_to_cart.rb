# frozen_string_literal: true

class AddToCart
  class Error < StandardError; end
  class ProductNotFound < Error; end

  extend Dry::Initializer

  option :current_user
  option :product_id

  def call
    adjust_quantity_and_price!
    cart_product_record.save!

    current_user.cart.products
  rescue ActiveRecord::RecordNotFound
    raise ProductNotFound, 'Product not found for given id.'
  end

  private

  def adjust_quantity_and_price!
    # TODO: call Rules here
    if cart_product_record.units.blank?
      cart_product_record.units = 1
    else
      cart_product_record.units += 1
    end

    cart_product_record.unit_price = given_product.price
  end

  def cart_product_record
    @cart_product_record ||= CartsProduct.find_or_initialize_by(
      cart_id: current_user.cart.id,
      product_id:
    )
  end

  def given_product
    @given_product ||= Product.find(product_id)
  end
end
