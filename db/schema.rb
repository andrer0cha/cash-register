# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 20_231_210_155_658) do
  create_table 'carts', force: :cascade do |t|
    t.integer 'user_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['user_id'], name: 'index_carts_on_user_id'
  end

  create_table 'carts_products', force: :cascade do |t|
    t.integer 'cart_id'
    t.integer 'product_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'units', default: 0, null: false
    t.decimal 'unit_price', default: '0.0', null: false
    t.index ['cart_id'], name: 'index_carts_products_on_cart_id'
    t.index ['product_id'], name: 'index_carts_products_on_product_id'
  end

  create_table 'products', force: :cascade do |t|
    t.string 'code', null: false
    t.string 'name', null: false
    t.decimal 'price', precision: 9, scale: 2, null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['code'], name: 'index_products_on_code', unique: true
  end

  create_table 'rule_types', force: :cascade do |t|
    t.string 'internal_reference', null: false
    t.string 'description', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'rules', force: :cascade do |t|
    t.integer 'trigger_product_id'
    t.integer 'trigger_amount', null: false
    t.string 'trigger_amount_type', null: false
    t.string 'trigger_amount_operator', null: false
    t.integer 'rule_type_id', null: false
    t.integer 'target_product_id'
    t.integer 'target_amount', null: false
    t.string 'target_amount_type', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['rule_type_id'], name: 'index_rules_on_rule_type_id'
    t.index ['target_product_id'], name: 'index_rules_on_target_product_id'
    t.index ['trigger_product_id'], name: 'index_rules_on_trigger_product_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'email', null: false
    t.string 'first_name', null: false
    t.string 'last_name', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['email'], name: 'index_users_on_email', unique: true
  end

  add_foreign_key 'rules', 'products', column: 'target_product_id'
  add_foreign_key 'rules', 'products', column: 'trigger_product_id'
end
