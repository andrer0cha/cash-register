# frozen_string_literal: true

FactoryBot.define do
  factory :cart do
    trait :with_products do
      create_list { :product }
    end
  end
end
