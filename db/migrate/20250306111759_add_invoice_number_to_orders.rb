class AddInvoiceNumberToOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :invoice_number, :string
  end
end
