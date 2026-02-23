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

ActiveRecord::Schema[8.1].define(version: 2025_02_23_140000) do
  create_table "products", force: :cascade do |t|
    t.string "brand", null: false
    t.string "colour"
    t.datetime "created_at", null: false
    t.string "currency", default: "ZAR"
    t.decimal "depth_cm", precision: 8, scale: 2
    t.text "description"
    t.json "features"
    t.decimal "feeder_capacity_kg", precision: 8, scale: 2
    t.string "finish"
    t.integer "fruit_diameter_max_mm"
    t.integer "fruit_diameter_min_mm"
    t.integer "fruits_per_minute"
    t.decimal "height_cm", precision: 8, scale: 2
    t.string "ip_rating"
    t.integer "lead_time_days"
    t.string "model", null: false
    t.decimal "price", precision: 12, scale: 2
    t.decimal "rrp", precision: 12, scale: 2
    t.string "sku"
    t.datetime "updated_at", null: false
    t.string "warranty_type"
    t.integer "warranty_years"
    t.integer "wattage"
    t.decimal "weight_kg", precision: 8, scale: 2
    t.decimal "width_cm", precision: 8, scale: 2
    t.index ["brand", "model"], name: "index_products_on_brand_and_model"
    t.index ["sku"], name: "index_products_on_sku", unique: true
  end
end
