# frozen_string_literal: true

class CreateRuleTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :rule_types do |t|
      t.string :internal_reference, null: false
      t.string :description, null: false

      t.timestamps
    end
  end
end
