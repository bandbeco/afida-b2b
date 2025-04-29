class ChangeHiddenDefaultInPriceListItems < ActiveRecord::Migration[8.0]
  def change
    change_column_default :price_list_items, :hidden, from: false, to: true
  end
end
