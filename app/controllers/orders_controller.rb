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
    @order = current_user.orders.build
    @shopping_cart = current_user.shopping_cart || current_user.create_shopping_cart
    build_shopping_cart_items
    @categorized_shopping_cart_items = categorized_shopping_cart_items
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders or /orders.json
  def create
    checkout = Checkout.new(current_user.shopping_cart)

    @order = current_user.orders.build(
      checkout.attributes.merge(order_params)
    )

    current_user.shopping_cart.shopping_cart_items.added_to_cart.each do |item|
      @order.order_items.build(
        product_id: item.product_id,
        quantity: item.quantity,
        unit_price: item.unit_price
      )
    end

    if order_params[:shipping_address]
      attn = "attn: #{order_params[:shipping_address][:attn]}"
      company = order_params[:shipping_address][:company]
      street_number_and_name = order_params[:shipping_address][:street_number_and_name]
      post_town = order_params[:shipping_address][:post_town]
      postcode = order_params[:shipping_address][:postcode]
      additional_notes = order_params[:shipping_address][:additional_notes]

    @order.shipping_address = [company, attn, street_number_and_name, post_town, postcode, additional_notes].join(", ").chomp(", ")
    end

    if order_params[:billing_address]
      company = order_params[:billing_address][:company]
      street_number_and_name = order_params[:billing_address][:street_number_and_name]
      post_town = order_params[:billing_address][:post_town]
      postcode = order_params[:billing_address][:postcode]

      @order.billing_address = [company, street_number_and_name, post_town, postcode].join(", ")
    end

    respond_to do |format|
      if @order.save
        OrderMailer
          .with(order: @order, user: current_user)
          .new_order_email
          .deliver_now

        format.html do
          current_user.shopping_cart.shopping_cart_items.destroy_all
          redirect_to order_url(@order), notice: "Order was successfully created."
        end
      else
        @shopping_cart = current_user.shopping_cart
        @categorized_shopping_cart_items = categorized_shopping_cart_items

        format.html { render :new, status: :unprocessable_entity }
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

  def categorized_shopping_cart_items
      current_user
        .shopping_cart
        .shopping_cart_items
        .includes(product: [:category, { picture_attachment: :blob }])
        .group_by { |item| item.product.category }
        .sort_by { |category, _| category.id }
  end

  def build_shopping_cart_items
    current_user.price_list_items.without_hidden.map do |item|
      @shopping_cart.shopping_cart_items.find_or_create_by(
        shopping_cart_id: @shopping_cart.id,
        product_id: item.product_id,
        unit_price: item.price
      )
    end
  end
end
