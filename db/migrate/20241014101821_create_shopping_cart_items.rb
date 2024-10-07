class CreateShoppingCartItems < ActiveRecord::Migration[7.2]
  def change
    create_table :shopping_cart_items do |t|
      t.references :shopping_cart, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :quantity, default: 0, null: false
      t.decimal :unit_price, null: false, precision: 10, scale: 2

      t.timestamps
    end
  end
end
