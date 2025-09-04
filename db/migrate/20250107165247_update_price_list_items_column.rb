# frozen_string_literal: true

class UpdatePriceListItemsColumn < ActiveRecord::Migration[7.2]
  def change
    change_column_null(:price_list_items, :price, false)
  end
end
