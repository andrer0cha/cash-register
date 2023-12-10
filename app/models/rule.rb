# frozen_string_literal: true

class Rule < ActiveRecord::Base
  belongs_to :trigger_product, optional: true, class_name: 'Product'
  belongs_to :target_product, optional: true, class_name: 'Product'
  belongs_to :rule_type

  VALID_AMOUNT_TYPES = %w[
    unit
    percentage
    cents
  ].freeze

  validates_inclusion_of(
    :trigger_amount_type, :target_amount_type, in: VALID_AMOUNT_TYPES
  )

  validates_presence_of(:trigger_amount,
                        :trigger_amount_type,
                        :trigger_amount_operator,
                        :target_amount,
                        :target_amount_type)

  enum trigger_amount_operator: {
    eq: '=',
    gte: '>=',
    gt: '>',
    lt: '<',
    lte: '<='
  }
end
