# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    code { Faker::Alphanumeric.alpha(number: 3).upcase }
    name { Faker::Commerce.product_name }
    price { Faker::Commerce.price }
  end
end
