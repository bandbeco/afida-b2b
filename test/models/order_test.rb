require "test_helper"

class OrderTest < ActiveSupport::TestCase
  setup do
    @order = Order.new(
        user: users(:one),
        status: 'pending',
        subtotal_amount: 100,
        shipping_address: '123 Main St',
        billing_address: '456, Wall St',
        payment_method: 'invoice'
      )
  end

  test "an order has shopping and confirmation steps" do
    order = Order.new
  assert_equal %w[shopping confirmation], order.steps
  end

  test "an order has two steps" do
    order = Order.new
    assert_equal 2, order.steps.count
  end

  test "the first step is shopping" do
    order = Order.new
    assert_equal 'shopping', order.steps.first
  end

  test "the last step is shopping" do
    order = Order.new
    assert_equal 'confirmation', order.steps.last
  end

  test "validates status presence" do
    @order.status = nil
    assert_not @order.valid?
  end

  test "validates subtotal_amount presence if last step" do
    @order.next_step
    @order.subtotal_amount = nil
    assert_not @order.valid?
  end

  test "validates shipping_address presence if last step" do
    @order.next_step
    @order.shipping_address = nil
    assert_not @order.valid?
  end

  test "validates billing_address presence if last step" do
    @order.next_step
    @order.billing_address = nil
    assert_not @order.valid?
  end

  test "validates payment_method presence if last step" do
    @order.next_step
    @order.payment_method = nil
    assert_not @order.valid?
  end

  test "formatted_order_id returns a formatted order id" do
    @order.save
    assert_equal "INV000#{@order.id}", @order.formatted_order_id
  end

  test "vat_amount returns the total amount multiplied by the VAT rate" do
    assert_equal 20, @order.vat_amount
  end

  test "shipping_amount returns 0 if total amount is greater than 100" do
    @order.subtotal_amount = 101
    assert_equal 0, @order.shipping_amount
  end

  test "shipping_amount returns 5 if total amount is less than or equal to 100" do
    @order.subtotal_amount = 100
    assert_equal 5, @order.shipping_amount
  end
end
