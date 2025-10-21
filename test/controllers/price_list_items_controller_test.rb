# frozen_string_literal: true

require "test_helper"

class PriceListItemsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:one)
    @price_list_item = price_list_items(:one)
  end

  test "should show price_list_item" do
    get price_list_item_url(@price_list_item)
    assert_response :success
  end
end
