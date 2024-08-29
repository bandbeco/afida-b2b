class AddHiddenToPriceListItems < ActiveRecord::Migration[7.2]
  def change
    add_column :price_list_items, :hidden, :boolean, default: false
  end
end
