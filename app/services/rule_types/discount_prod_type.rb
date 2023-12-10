# frozen_string_literal: true

module RuleTypes
  class DiscountProdType
    extend Dry::Initializer

    option :cart
    option :target_product
    option :target_amount
    option :target_amount_type

    def call
      return false unless carts_products.any?

      ActiveRecord::Base.transaction do
        case target_amount_type
        when 'percentage'
          discount_prod_type_in_percentage!
        when 'cents'
          discount_prod_type_in_cents!
        else
          false
        end
      end
    end

    private

    def discount_prod_type_in_cents!
      carts_products.each do |cart_product|
        new_price = cart_product.unit_price - target_amount

        return false if new_price.negative?

        cart_product.update!(
          unit_price: new_price
        )
      end
    end

    def carts_products
      @carts_products ||= CartsProduct.where(
        cart:,
        product: target_product
      )
    end

    def discount_prod_type_in_percentage!
      carts_products.each do |cart_product|
        new_price = cart_product.unit_price * ((100.0 - target_amount.to_f) / 100.0)

        return false if new_price.negative?

        cart_product.update!(
          unit_price: new_price
        )
      end
    end
  end
end
