# Preview all emails at http://localhost:3000/rails/mailers/order_mailer
class OrderMailerPreview < ActionMailer::Preview

  def new_order_email
    OrderMailer
      .with(order: Order.last, user: User.first)
      .new_order_email
  end
end
