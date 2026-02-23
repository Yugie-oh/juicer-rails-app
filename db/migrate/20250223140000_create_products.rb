# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.string :brand, null: false
      t.string :model, null: false
      t.string :colour
      t.string :finish
      t.string :sku
      t.decimal :price, precision: 12, scale: 2
      t.string :currency, default: "ZAR"
      t.decimal :rrp, precision: 12, scale: 2
      t.decimal :width_cm, precision: 8, scale: 2
      t.decimal :depth_cm, precision: 8, scale: 2
      t.decimal :height_cm, precision: 8, scale: 2
      t.decimal :weight_kg, precision: 8, scale: 2
      t.integer :wattage
      t.string :ip_rating
      t.integer :fruits_per_minute
      t.decimal :feeder_capacity_kg, precision: 8, scale: 2
      t.integer :fruit_diameter_min_mm
      t.integer :fruit_diameter_max_mm
      t.integer :warranty_years
      t.string :warranty_type
      t.integer :lead_time_days
      t.text :description
      t.json :features

      t.timestamps
    end

    add_index :products, :sku, unique: true
    add_index :products, [:brand, :model]
  end
end
