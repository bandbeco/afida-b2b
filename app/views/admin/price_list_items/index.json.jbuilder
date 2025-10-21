# frozen_string_literal: true

json.array! @price_list_items, partial: "price_list_items/price_list_item", as: :price_list_item
