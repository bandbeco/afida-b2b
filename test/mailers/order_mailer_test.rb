# frozen_string_literal: true

require 'test_helper'

class OrderMailerTest < ActionMailer::TestCase
  setup do
    @order = orders(:one)
    @user = users(:one)
    @email = OrderMailer.with(order: @order, user: @user).new_order_email
  end

  def html_body
    @email.deliver_now
    @email.parts.find { |p| p.content_type.match(/html/) }.body.to_s
  end

  test 'email has correct headers' do
    assert_emails 1 do
      @email.deliver_now
    end

    assert_equal ['orders@afida.com'], @email.bcc
    assert_equal [@user.email], @email.to
    assert_equal 'Your order has been placed!', @email.subject
  end

  test 'email contains order details' do
    email_body = html_body

    # Order information
    assert_includes email_body, "<strong>Order Number:</strong> #{@order.invoice_number}"
    assert_includes email_body, '<strong>Shipping Address:</strong>'
    assert_includes email_body, @order.shipping_address
    assert_includes email_body, '<strong>Billing Address:</strong>'
    assert_includes email_body, @order.billing_address
  end

  test 'email contains product details' do
    email_body = html_body
    order_item = @order.order_items.first
    product = order_item.product

    # Product information
    assert_includes email_body, "<strong>Item:</strong> #{product.name}"
    assert_includes email_body, "<strong>SKU:</strong> #{product.sku}"
    assert_includes email_body, "<strong>Colour:</strong> #{product.colour&.titleize}"
    assert_includes email_body, "<strong>PAC Size:</strong> #{product.pac_size} pieces"
    assert_includes email_body, "<strong>Quantity:</strong> #{order_item.quantity}"
    assert_includes email_body, "<strong>Price:</strong> £#{order_item.unit_price}"
    assert_includes email_body, "<strong>Total:</strong> £#{order_item.unit_price * order_item.quantity}"
  end

  test 'email contains order totals' do
    email_body = html_body

    # Order totals
    assert_includes email_body, "<strong>Subtotal:</strong> £#{@order.subtotal_amount}"
    assert_includes email_body, "<strong>Shipping:</strong> £#{@order.shipping_amount}"
    assert_includes email_body, "<strong>VAT 20%:</strong> £#{@order.vat_amount}"
    assert_includes email_body, "<strong>Total:</strong> £#{@order.total_amount}"
  end

  test 'email contains payment and delivery information' do
    email_body = html_body

    assert_includes email_body, "<strong>Payment method:</strong> #{@order.payment_method}"
    assert_includes email_body, '<strong>Estimated delivery:</strong> 1-2 working days'
  end

  test 'email contains customer service information' do
    email_body = html_body

    assert_includes email_body, 'hello@afida.com'
    assert_includes email_body, 'Thank you for choosing Afida'
  end

  test 'handles nil product colour gracefully' do
    product = @order.order_items.first.product
    product.update!(colour: nil)

    email = OrderMailer.with(order: @order, user: @user).new_order_email
    email_body = email.deliver_now.parts.find { |p| p.content_type.match(/html/) }.body.to_s

    assert_includes email_body, '<strong>Colour:</strong>'
    assert_not_includes email_body, 'nil'
  end
end
