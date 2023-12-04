# frozen_string_literal: true

class Product < ActiveRecord::Base
  has_many :carts_products, dependent: :destroy, inverse_of: :product
  has_many :carts, through: :carts_products

  validates :code, uniqueness: true, presence: true
  validates_presence_of(:price, :name)
end
