# frozen_string_literal: true

class RuleType < ActiveRecord::Base
  validates :description, presence: true
  validates :internal_reference, uniqueness: true

  enum internal_reference: {
    add_item: 'add_item',
    discount_cart: 'discount_cart',
    free_shipping: 'free_shipping',
    set_price_prod_type: 'set_price_prod_type',
    set_price_single_unity: 'set_price_single_unity',
    discount_prod_type: 'discount_prod_type',
    discount_single_unity: 'discount_single_unity'
  }
end
