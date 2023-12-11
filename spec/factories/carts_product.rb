# frozen_string_literal: true

FactoryBot.define do
  factory :carts_product do
    product
    cart
    unit_price { product.price }
  end
end
