class AddDefaultAddressesToUsers < ActiveRecord::Migration[7.2]
  def change
    add_reference :users, :default_shipping_address, null: true, foreign_key: { to_table: :addresses, on_delete: :nullify }
    add_reference :users, :default_billing_address, null: true, foreign_key: { to_table: :addresses, on_delete: :nullify }
  end
end
