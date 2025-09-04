# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    enable_extension('citext') # case-insensitive text

    create_table :products do |t|
      t.citext :sku, index: true, null: false # index SKUs on case-insensitive text
      t.string :name, null: false
      t.text :description
      t.string :colour
      t.integer :pac_size
      t.decimal :price, precision: 10, scale: 2, null: false
      t.integer :width_in_mm
      t.integer :depth_in_mm
      t.integer :height_in_mm
      t.integer :diameter_in_mm
      t.integer :volume_in_ml

      t.timestamps
    end
  end
end
