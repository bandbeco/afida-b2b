module ApplicationHelper
  def currency_for(amount)
    number_to_currency(amount, locale: :en)
  end

  def order_summary_pdf(order)
    pdf = Prawn::Document.new
    pdf.font 'Courier'
    pdf.font_size 10
    pdf.stroke_color 'e6e6e6'

    pdf.image "#{Rails.root}/app/assets/images/logo.png", width: 50
    pdf.move_down 20

    pdf.text "Order ##{order.id}", size: 20, style: :bold
    pdf.move_down 30

    order.order_items.each do |order_item|
      pdf.text "#{order_item.product.name}", style: :bold
      pdf.text "SKU: #{order_item.product.sku}"
      if order_item.product.pac_size.present?
        pdf.text "PAC Size: #{order_item.product.pac_size} pieces"
      end
      pdf.move_up 30
      pdf.text "Quantity: #{order_item.quantity}", align: :right
      pdf.text "Unit Price: #{currency_for(order_item.unit_price)}", align: :right
      pdf.text "Total: #{currency_for(order_item.unit_price * order_item.quantity)}", align: :right
      pdf.move_down 10
      pdf.stroke_horizontal_line 0, 550
      pdf.move_down 10
    end

    pdf.text "Subtotal: #{currency_for(@order.subtotal_amount)}", align: :right
    pdf.text "Shipping: #{currency_for(@order.shipping_amount)}", align: :right
    pdf.text "VAT 20%: #{currency_for(@order.vat_amount)}", align: :right

    pdf.move_down 10
    pdf.stroke_horizontal_line 0, 550
    pdf.move_down 10

    pdf.text "<b>Total</b>: #{currency_for(@order.total_amount)}", inline_format: true, align: :right
    pdf.move_down 30

    pdf.text "Payment method", style: :bold
    pdf.text @order.payment_method
    pdf.move_down 20
    pdf.text "Shipping address", style: :bold
    pdf.text @order.shipping_address
    pdf.move_down 20
    pdf.text "Billing address", style: :bold
    pdf.text @order.billing_address

    pdf
  end
end
