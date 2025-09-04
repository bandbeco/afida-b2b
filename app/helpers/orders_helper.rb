# frozen_string_literal: true

module OrdersHelper
  include ActionView::Helpers::NumberHelper

  def user_addresses
    current_user.addresses.map do |address|
      [
        address.formatted_address,
        address.formatted_address
      ]
    end
  end

  def order_summary_pdf(order)
    Prawn::Fonts::AFM.hide_m17n_warning = true
    pdf = Prawn::Document.new
    pdf.font 'Courier'
    pdf.font_size 10
    pdf.stroke_color 'e6e6e6'

    pdf.image Rails.root.join('app/assets/images/logo.png').to_s, width: 50
    pdf.move_down 20

    pdf.text "Order ##{order.invoice_number}", size: 20, style: :bold
    pdf.text "Placed on #{order.created_at.strftime('%d %B %Y at %H:%M')}"
    pdf.move_down 40

    order.order_items.each do |order_item|
      pdf.text order_item.product.name.to_s, style: :bold
      pdf.move_down 2
      pdf.text "SKU: #{order_item.product.sku}"
      pdf.move_down 2
      pdf.text "Colour: #{order_item.product.colour&.titleize}"
      pdf.move_down 2
      pdf.text "PAC Size: #{order_item.product.pac_size} pieces" if order_item.product.pac_size.present?
      pdf.move_up 30
      pdf.text "Quantity: #{order_item.quantity}", align: :right
      pdf.move_down 2
      pdf.text "Unit Price: #{currency_for(order_item.unit_price)}", align: :right
      pdf.move_down 2
      pdf.text "Total: #{currency_for(order_item.unit_price * order_item.quantity)}", align: :right
      pdf.move_down 10
      pdf.stroke_horizontal_line 0, 550
      pdf.move_down 10
    end

    pdf.text "Subtotal  #{currency_for(order.subtotal_amount)}", align: :right
    pdf.move_down 2
    pdf.text "Shipping  #{currency_for(order.shipping_amount)}", align: :right
    pdf.move_down 2
    pdf.text "VAT 20%  #{currency_for(order.vat_amount)}", align: :right

    pdf.move_down 10
    pdf.stroke_color '000000'
    pdf.stroke_horizontal_line 0, 550
    pdf.move_down 10

    pdf.text "<b>Total</b>: #{currency_for(order.total_amount)}", inline_format: true, align: :right
    pdf.move_down 30

    pdf.text 'Payment method', style: :bold
    pdf.text order.payment_method
    pdf.move_down 20
    pdf.text 'Shipping address', style: :bold
    pdf.text order.shipping_address
    pdf.move_down 20
    pdf.text 'Billing address', style: :bold
    pdf.text order.billing_address

    pdf
  end

  private

  def currency_for(amount)
    number_to_currency(amount, locale: :en)
  end
end
