require "test_helper"

class OrderMailerTest < ActionMailer::TestCase
  test "order confirmation email" do
    order = orders(:one)
    user = users(:one)
    email = OrderMailer.with(order: order, user: user).new_order_email

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ["orders@afida.com"], email.bcc
    assert_equal [user.email], email.to
    assert_equal "Your order has been placed!", email.subject

    assert_includes email.body.to_s, "<strong>Item:</strong> Product One"
    assert_includes email.body.to_s, "<strong>SKU:</strong> p-one"
    assert_includes email.body.to_s, "<strong>Quantity:</strong> 2"
    assert_includes email.body.to_s, "<strong>PAC Size:</strong> 1000 pieces"
    assert_includes email.body.to_s, "<strong>Price:</strong> £11.00"
    assert_includes email.body.to_s, "<strong>Total:</strong> £22.00"
  end
end
