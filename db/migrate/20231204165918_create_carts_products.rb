# frozen_string_literal: true

class CreateCartsProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :carts_products do |t|
      t.belongs_to :cart
      t.belongs_to :product

      t.timestamps
    end
  end
end
