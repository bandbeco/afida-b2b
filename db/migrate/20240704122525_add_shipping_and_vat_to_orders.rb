class AddShippingAndVatToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :shipping_amount, :decimal, precision: 10, scale: 2
    add_column :orders, :vat_rate, :decimal, precision: 10, scale: 2
    add_column :orders, :vat_amount, :decimal, precision: 10, scale: 2
    add_column :orders, :subtotal_amount, :decimal, precision: 10, scale: 2, null: false
  end
end
