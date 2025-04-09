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

    # Load addresses for the form
    @addresses = current_user.addresses.order(:created_at)
    @default_shipping_address = current_user.default_shipping_address
    @default_billing_address = current_user.default_billing_address

    # Pre-select default addresses in dropdowns
    if @default_shipping_address
      @order.selected_shipping_address_id = @default_shipping_address.id
    end

    if @default_billing_address
      @order.selected_billing_address_id = @default_billing_address.id
    end
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

    respond_to do |format|
      if @order.save
        save_addresses_from_order(@order)

        OrderMailer
          .with(order: @order, user: current_user)
          .new_order_email
          .deliver_now

        format.html do
          current_user.shopping_cart.shopping_cart_items.destroy_all
          redirect_to order_url(@order), notice: "Order was successfully created."
        end
      else
        # Need to reload addresses for the form if rendering :new
        @addresses = current_user.addresses.order(:created_at)
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
        :payment_method,
        # New form fields
        :selected_shipping_address_id,
        :selected_billing_address_id,
        :use_shipping_for_billing,
        # Shipping fields
        :shipping_company, :shipping_attn, :shipping_building_name, :shipping_street_number_and_name,
        :shipping_post_town, :shipping_postcode, :shipping_additional_notes,
        # Billing fields
        :billing_company, :billing_attn, :billing_building_name, :billing_street_number_and_name,
        :billing_post_town, :billing_postcode, :billing_additional_notes,
        # Existing fields (keep total_amount? checkout service might handle this)
        :total_amount,
        :save_shipping_address,
        :save_billing_address,
        # Keep order_items_attributes
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

  def save_addresses_from_order(order)
    # Save shipping address if checkbox ticked and it was a new entry
    if order.save_shipping_address == '1' && (order.selected_shipping_address_id.blank? || order.selected_shipping_address_id == 'new')
      current_user.addresses.create(
        company: order.shipping_company,
        attn: order.shipping_attn,
        building_name: order.shipping_building_name,
        street_number_and_name: order.shipping_street_number_and_name,
        post_town: order.shipping_post_town,
        postcode: order.shipping_postcode,
        additional_notes: order.shipping_additional_notes
      ) # Consider adding error handling for address creation failure
    end

    # Save billing address if checkbox ticked, not using shipping, and it was a new entry
    if order.save_billing_address == '1' && order.use_shipping_for_billing != '1' && (order.selected_billing_address_id.blank? || order.selected_billing_address_id == 'new')
      current_user.addresses.create(
        company: order.billing_company,
        attn: order.billing_attn,
        building_name: order.billing_building_name,
        street_number_and_name: order.billing_street_number_and_name,
        post_town: order.billing_post_town,
        postcode: order.billing_postcode,
        additional_notes: order.billing_additional_notes
      ) # Consider adding error handling
    end
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
