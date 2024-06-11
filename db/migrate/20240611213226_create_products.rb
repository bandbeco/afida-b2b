class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :sku
      t.string :name
      t.text :description
      t.string :colour
      t.integer :pac_size
      t.decimal :price
      t.integer :width_in_mm
      t.integer :height_in_mm

      t.timestamps
    end
  end
end
