# frozen_string_literal: true

require "test_helper"

class OrderItemTest < ActiveSupport::TestCase
  test "should not save order item without quantity" do
    order_item = OrderItem.new
    assert_not order_item.save
  end

  test "should not save order item without unit price" do
    order_item = OrderItem.new
    assert_not order_item.save
  end
end
