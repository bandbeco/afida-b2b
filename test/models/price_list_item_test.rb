# frozen_string_literal: true

require 'test_helper'

class PriceListItemTest < ActiveSupport::TestCase
  test 'should not save price list item without price' do
    price_list_item = PriceListItem.new
    assert_not price_list_item.save
  end
end
