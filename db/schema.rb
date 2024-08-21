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

ActiveRecord::Schema[7.1].define(version: 2024_08_21_172120) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "constraints", force: :cascade do |t|
    t.bigint "part_id", null: false
    t.bigint "constraint_part_id", null: false
    t.bigint "constraint_option_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["constraint_option_id"], name: "index_constraints_on_constraint_option_id"
    t.index ["constraint_part_id"], name: "index_constraints_on_constraint_part_id"
    t.index ["part_id"], name: "index_constraints_on_part_id"
  end

  create_table "options", force: :cascade do |t|
    t.bigint "part_id", null: false
    t.string "name", null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.boolean "is_in_stock", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["part_id"], name: "index_options_on_part_id"
  end

  create_table "parts", force: :cascade do |t|
    t.string "name", null: false
    t.string "product_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_configurations", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "option_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["option_id"], name: "index_product_configurations_on_option_id"
    t.index ["product_id"], name: "index_product_configurations_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name", null: false
    t.string "product_type", null: false
    t.decimal "base_price", precision: 10, scale: 2, null: false
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stock_levels", force: :cascade do |t|
    t.bigint "option_id", null: false
    t.integer "quantity", default: 0, null: false
    t.boolean "is_in_stock", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["option_id"], name: "index_stock_levels_on_option_id"
  end

  add_foreign_key "constraints", "options", column: "constraint_option_id"
  add_foreign_key "constraints", "parts"
  add_foreign_key "constraints", "parts", column: "constraint_part_id"
  add_foreign_key "options", "parts"
  add_foreign_key "product_configurations", "options"
  add_foreign_key "product_configurations", "products"
  add_foreign_key "stock_levels", "options"
end
