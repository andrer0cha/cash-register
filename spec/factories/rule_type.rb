# frozen_string_literal: true

FactoryBot.define do
  factory :rule_type do
    internal_reference { RuleType.internal_references.keys.sample }
    description { 'Lorem ipsum dolor sit amet.' }
  end
end
