# frozen_string_literal: true

class UpdateAmountColumns < ActiveRecord::Migration[7.1]
  def change
    change_table :rules do |t|
      t.change :target_amount, :decimal
      t.change :trigger_amount, :decimal
    end
  end
end
