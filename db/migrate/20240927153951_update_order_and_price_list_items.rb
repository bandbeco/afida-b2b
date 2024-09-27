class UpdateOrderAndPriceListItems < ActiveRecord::Migration[7.2]
  def change
    change_column_null(:order_items, :unit_price, false)
    change_column_null(:price_list_items, :price, false)
  end
end
