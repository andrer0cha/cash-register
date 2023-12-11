# frozen_string_literal: true

class CleanupUnitsColumn < ActiveRecord::Migration[7.1]
  def change
    remove_column :carts_products, :units
  end
end
