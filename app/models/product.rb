# frozen_string_literal: true

class Product < ActiveRecord::Base
  validates :code, uniqueness: true, presence: true
  validates_presence_of(:price, :name)
end
