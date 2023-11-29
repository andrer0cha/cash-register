# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string  :code, null: false, index: { unique: true }
      t.string  :name, null: false
      t.decimal :price, null: false, precision: 9, scale: 2

      t.timestamps
    end
  end
end
