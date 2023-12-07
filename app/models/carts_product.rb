# frozen_string_literal: true

class CartsProduct < ActiveRecord::Base
  belongs_to :cart
  belongs_to :product

  validates :units, presence: true
  validates :unit_price, presence: true
  validates :cart_id, uniqueness: { scope: :product_id }
end
