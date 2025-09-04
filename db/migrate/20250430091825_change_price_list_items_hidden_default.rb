# frozen_string_literal: true

class ChangePriceListItemsHiddenDefault < ActiveRecord::Migration[8.0]
  def change
    change_column_default :price_list_items, :hidden, from: true, to: false
  end
end
