# frozen_string_literal: true

class CreateRules < ActiveRecord::Migration[7.1]
  def change
    create_table :rules do |t|
      t.references :trigger_product, foreign_key: { to_table: :products }
      t.integer :trigger_amount, null: false
      t.string  :trigger_amount_type, null: false
      t.string  :trigger_amount_operator, null: false
      t.references :rule_type, null: false
      t.references :target_product, foreign_key: { to_table: :products }
      t.integer :target_amount, null: false
      t.string  :target_amount_type, null: false

      t.timestamps
    end
  end
end
