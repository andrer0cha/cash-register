# frozen_string_literal: true

module RuleTypes
  class SetPriceProdType
    extend Dry::Initializer

    option :cart
    option :target_product
    option :target_price

    def call
      return false unless set_prod_type_prices!

      true
    end

    private

    def set_prod_type_prices!
      products = CartsProduct.where(
        cart:,
        product: target_product
      )

      return false unless products.any?

      products.update_all(
        unit_price: target_price
      )
    end
  end
end
