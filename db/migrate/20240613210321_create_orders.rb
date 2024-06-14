class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.integer :status, default: 0, null: false
      t.decimal :total_amount, precision: 10, scale: 2, null: false
      t.text :shipping_address, null: false
      t.text :billing_address, null: false

      t.timestamps
    end
  end
end
