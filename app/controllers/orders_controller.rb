class OrdersController < ApplicationController
  load_and_authorize_resource

  before_action :set_order, only: %i[ show edit update destroy ]

  # GET /orders or /orders.json
  def index
    if current_user.admin?
      @orders = Order.all.order(created_at: :desc)
    else
      @orders = current_user.orders.order(created_at: :desc)
    end
  end

  # GET /orders/1 or /orders/1.json
  def show
    respond_to do |format|
      format.html
      format.pdf do
        send_data helpers.order_summary_pdf.render,
          type: "application/pdf",
          disposition: "inline"
      end
    end
  end

  # GET /orders/new
  def new
    session[:order_params] ||= {}
    @order = current_user.orders.build(session[:order_params])
    @categorized_price_list_items = categorized_price_list_items
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders or /orders.json
  def create
    @order_params = order_params
    session[:order_params].deep_merge!(order_params) if order_params
    @order = current_user.orders.build(session[:order_params])
    @order.current_step = session[:order_step]
    @order.subtotal_amount = @order.order_items.sum(&:total_price)
    @order.shipping_amount = @order.subtotal_amount > 100 ? 0 : 5.00
    @order.vat_rate = Order::VAT_RATE
    @order.vat_amount = @order.subtotal_amount * @order.vat_rate
    @order.total_amount = @order.subtotal_amount + @order.vat_amount + @order.shipping_amount

    if order_params[:shipping_address]
      attn = "attn: #{order_params[:shipping_address][:attn]}"
      company = order_params[:shipping_address][:company]
      street_number_and_name = order_params[:shipping_address][:street_number_and_name]
      post_town = order_params[:shipping_address][:post_town]
      postcode = order_params[:shipping_address][:postcode]
      additional_notes = order_params[:shipping_address][:additional_notes]

      @order.shipping_address = [company, attn, street_number_and_name, post_town, postcode, additional_notes].join(", ")
    end

    if order_params[:billing_address]
      company = order_params[:shipping_address][:company]
      street_number_and_name = order_params[:shipping_address][:street_number_and_name]
      post_town = order_params[:shipping_address][:post_town]
      postcode = order_params[:shipping_address][:postcode]

      @order.billing_address = [company, street_number_and_name, post_town, postcode].join(", ")
    end

    if @order.valid?
      if @order.last_step?
        if @order.all_valid?
          @order.save

          OrderMailer
            .with(order: @order, user: current_user)
            .new_order_email
            .deliver_now

          Honeybadger.event(
            "Created New Order",
            order_id: @order.id,
            user: current_user.email,
          )
        end
      else
        @order.next_step
      end
      session[:order_step] = @order.current_step
    end

    respond_to do |format|
      if @order.new_record?
        @categorized_price_list_items = categorized_price_list_items
        format.html { render :new, status: :ok }
      else
        session[:order_step] = session[:order_params] = nil
        format.html { redirect_to order_url(@order), notice: "Order was successfully created." }
      end
    end
  end

  # PATCH/PUT /orders/1 or /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to order_url(@order), notice: "Order was successfully updated." }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1 or /orders/1.json
  def destroy
    @order.destroy!

    respond_to do |format|
      format.html { redirect_to orders_url, notice: "Order was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_order
    if current_user.admin?
      @order = Order.find(params[:id])
    else
      @order = current_user.orders.find(params[:id])
    end
  end

  # Only allow a list of trusted parameters through.
  def order_params
    params
      .require(:order)
      .permit(
        :status,
        :total_amount,
        :shipping_address,
        :billing_address,
        :payment_method,
        shipping_address: %i[company attn street_number_and_name post_town postcode additional_notes],
        billing_address: %i[company attn street_number_and_name post_town postcode],
        order_items_attributes: [
          :id,
          :order_id,
          :product_id,
          :quantity,
          :unit_price,
          :_destroy
        ]
      )
  end

  def categorized_price_list_items
      current_user
        .price_list_items
        .without_hidden
        .includes(product: [:category, { picture_attachment: :blob }])
        .group_by(&:category)
  end
end
