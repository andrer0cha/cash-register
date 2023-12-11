# frozen_string_literal: true

class ApplyRuleToCart
  extend Dry::Initializer

  option :rule
  option :cart

  def call
    return unless should_apply?

    case rule.rule_type.internal_reference
    when 'bxgy'
      ::RuleTypes::BuyXAndGetY.new(
        product_to_add: target_product,
        cart:,
        rule_trigger_amount: rule.trigger_amount,
        rule_target_amount: rule.target_amount
      ).call
    when 'set_price_prod_type'
      ::RuleTypes::SetPriceProdType.new(
        cart:,
        target_product:,
        target_price: rule.target_amount
      ).call
    when 'discount_prod_type'
      ::RuleTypes::DiscountProdType.new(
        cart:,
        target_product:,
        target_amount: rule.target_amount,
        target_amount_type: rule.target_amount_type
      ).call
    end
  end

  private

  def should_apply?
    Rule.where(
      "#{trigger_product_amount} #{operator} trigger_amount"
    ).include?(rule)
  end

  def operator
    Rule.trigger_amount_operators[rule.trigger_amount_operator]
  end

  def trigger_product_amount
    case rule.trigger_amount_type
    when 'unit'
      if rule.trigger_product_id
        cart.carts_products.where(
          product_id: rule.trigger_product_id
        ).count
      else
        cart.carts_products.count
      end
    when 'cents'
      if rule.trigger_product_id
        cart.carts_products.where(
          product_id: rule.trigger_product_id
        ).sum(:unit_price).to_f / 100.0
      else
        cart.carts_products.sum(:unit_price).to_f / 100.0
      end
    end
  end

  def target_product
    return nil unless rule.target_product_id

    Product.find(rule.target_product_id)
  end
end
