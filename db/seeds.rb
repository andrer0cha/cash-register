# frozen_string_literal: true

[
  { code: 'GR1', name: 'Green Tea', price: 3.11 },
  { code: 'SR1', name: 'Strawberry', price: 5.00 },
  { code: 'CF1', name: 'Coffee', price: 11.23 }
].each do |product_arguments|
  Product.create!(product_arguments)
end

UserCreator.new(
  first_name: 'Current',
  last_name: 'User',
  email: 'current.user@example.com'
).call # already creates necessary associations (Cart)

[
  { internal_reference: 'bxgy', description: 'Buy X get Y items of same type.' },
  { internal_reference: 'discount_cart', description: 'Give discount to entire cart.' },
  { internal_reference: 'free_shipping', description: 'Give free shipping.' },
  { internal_reference: 'set_price_prod_type', description: 'Set fixed price to product.' },
  { internal_reference: 'discount_prod_type',
    description: 'Give discount to all products of same type.' },
  { internal_reference: 'discount_single_unity',
    description: 'Give discount to a single unit of a product.' }
].each do |rule_type_arguments|
  RuleType.create!(rule_type_arguments)
end

[
  {
    trigger_product_id: Product.first.id,
    trigger_amount: 1,
    trigger_amount_type: 'unit',
    trigger_amount_operator: 'gte',
    rule_type: RuleType.find_by(internal_reference: 'bxgy'),
    target_product_id: Product.first.id,
    target_amount: 1,
    target_amount_type: 'unit'
  },
  {
    trigger_product_id: Product.second.id,
    trigger_amount: 3,
    trigger_amount_type: 'unit',
    trigger_amount_operator: 'gte',
    rule_type: RuleType.find_by(internal_reference: 'set_price_prod_type'),
    target_product_id: Product.second.id,
    target_amount: 450,
    target_amount_type: 'cents'
  },
  {
    trigger_product_id: Product.third.id,
    trigger_amount: 3,
    trigger_amount_type: 'unit',
    trigger_amount_operator: 'gte',
    rule_type: RuleType.find_by(internal_reference: 'discount_prod_type'),
    target_product_id: Product.third.id,
    target_amount: 33,
    target_amount_type: 'percentage'
  }
].each do |rule_argument|
  Rule.create!(rule_argument)
end
