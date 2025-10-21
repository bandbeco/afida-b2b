# frozen_string_literal: true

class OrderMailer < ApplicationMailer
  include OrdersHelper

  default bcc: "orders@afida.com"

  def new_order_email
    @order = params[:order]
    @user = params[:user]

    attachments["order_#{@order.id}_summary.pdf"] = order_summary_pdf(@order).render

    mail(
      to: @user.email,
      subject: "Your order has been placed!"
    )
  end
end
