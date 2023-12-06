# frozen_string_literal: true

FactoryBot.define do
  factory :carts_product do
    product
    cart
    units { 1 }
    unit_price { product.price }
  end
end
