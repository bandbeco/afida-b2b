class OrderMailer < ApplicationMailer
  default bcc: -> { User.admin.pluck(:email) }

  def new_order_email
    @order = params[:order]
    @user = params[:user]

    mail(
      to: @user.email, 
      subject: "Your order has been placed!"
    )
  end
end
