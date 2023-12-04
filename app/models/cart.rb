# frozen_string_literal: true

class Cart < ActiveRecord::Base
  belongs_to :user, dependent: :destroy
  has_many :carts_products, dependent: :destroy, inverse_of: :cart
  has_many :products, through: :carts_products
end
