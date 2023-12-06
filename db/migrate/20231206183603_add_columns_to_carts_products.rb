# frozen_string_literal: true

class AddColumnsToCartsProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :carts_products, :units, :integer, null: false
    add_column :carts_products, :unit_price, :decimal, null: false
  end
end
