require "test_helper"

class OrderTest < ActiveSupport::TestCase
  setup do
    @order = Order.create!(
      user: users(:one),
      status: 'pending',
      subtotal_amount: 100,
      shipping_address: '123 Main St',
      billing_address: '456, Wall St',
      payment_method: 'invoice',
      total_amount: 100,
      order_items_attributes: [{
        product: products(:one),
        quantity: 1,
        unit_price: 100
      }]
    )
  end

  test "validates subtotal_amount presence" do
    @order.subtotal_amount = nil
    assert_not @order.valid?
  end

  test "validates shipping_address presence" do
    @order.shipping_address = nil
    assert_not @order.valid?
  end

  test "validates billing_address presence" do
    @order.billing_address = nil
    assert_not @order.valid?
  end

  test "validates payment_method presence" do
    @order.payment_method = nil
    assert_not @order.valid?
  end

  test "invoice_number returns a formatted order id" do
    assert_equal "ONL-000#{@order.id}", @order.invoice_number
  end

  test "invoice_number is generated after create" do
    assert_equal "ONL-000#{@order.id}", @order.invoice_number
  end
end
