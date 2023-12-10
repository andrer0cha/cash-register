# frozen_string_literal: true

module RuleTypes
  class AddItem
    extend Dry::Initializer

    option :product_to_add
    option :cart
    option :qty_to_add

    def call
      return false unless add_items!

      true
    rescue ActiveRecord::RecordNotUnique
      false
    end

    private

    def add_items!
      CartsProduct.insert_all!(
        attributes_list
      )

      true
    end

    def attributes_list
      qty_to_add.times.map do
        {
          cart_id: cart.id,
          product_id: product_to_add.id,
          unit_price: 0
        }
      end
    end
  end
end
