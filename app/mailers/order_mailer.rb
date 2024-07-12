class OrderMailer < ApplicationMailer

  def new_order_email
    @order = params[:order]
    @user = params[:user]

    mail(
      to: @user.email, 
      subject: "Your order has been placed!"
    )
  end
end
