# frozen_string_literal: true

module RuleTypes
  class BuyXAndGetY
    extend Dry::Initializer

    option :product_to_add
    option :cart
    option :rule_trigger_amount
    option :rule_target_amount

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
      missing_free_items_qty.to_i.times.map do
        {
          cart_id: cart.id,
          product_id: product_to_add.id,
          unit_price: 0
        }
      end
    end

    def missing_free_items_qty
      expected_free_items - free_items
    end

    def expected_free_items
      (rule_target_amount / rule_trigger_amount) * paid_items.to_f
    end

    def paid_items
      @paid_items ||= cart_product_items.where.not(unit_price: 0).count
    end

    def cart_product_items
      @cart_product_items ||= cart.carts_products.where(
        product: product_to_add.id
      )
    end

    def free_items
      @free_items ||= cart_product_items.where(unit_price: 0).count
    end
  end
end
