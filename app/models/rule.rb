# frozen_string_literal: true

class Rule < ActiveRecord::Base
  belongs_to :trigger_product, optional: true, class_name: 'Product'
  belongs_to :target_product, optional: true, class_name: 'Product'

  validates_presence_of(:trigger_amount,
                        :trigger_amount_type,
                        :trigger_amount_operator,
                        :action,
                        :target_amount,
                        :target_amount_type)

  enum action: {
    add_item: 'add_item',
    discount: 'discount',
    set_price: 'set_price'
  }
end
