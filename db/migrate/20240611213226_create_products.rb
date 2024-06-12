class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :sku, index: true, null: false
      t.string :name, null: false
      t.text :description
      t.string :colour
      t.integer :pac_size
      t.decimal :price, precision: 10, scale: 2, null: false
      t.integer :width_in_mm
      t.integer :height_in_mm

      t.timestamps
    end
  end
end
