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
    apply_rules_to_cart!

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

  def apply_rules_to_cart!
    return unless rules_to_apply.any?

    rules_to_apply.each do |rule|
      ApplyRuleToCart.new(
        rule:,
        cart: current_user.cart
      ).call
    end
  end

  def rules_to_apply
    @rules_to_apply ||= Rule.where(
      '(trigger_product_id = ? OR trigger_product_id IS NULL)',
      product.id
    )
  end

  def operator(rule_to_apply)
    Rule.trigger_amount_operators[rule_to_apply.trigger_amount_operator]
  end
end
