# frozen_string_literal: true

FactoryBot.define do
  factory :rule do
    trigger_amount { 3 }
    trigger_amount_type { 'unit' }
    trigger_amount_operator { 'gte' }
    rule_type
    target_amount { 10 }
    target_amount_type { 'percentage' }

    trait :with_trigger_product do
      trigger_product
    end
    trait :with_target_product do
      target_product
    end
  end
end
