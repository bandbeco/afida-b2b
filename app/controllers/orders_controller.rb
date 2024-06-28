class OrdersController < ApplicationController
  before_action :set_order, only: %i[ show edit update destroy ]

  # GET /orders or /orders.json
  def index
    @orders = current_user.orders
  end

  # GET /orders/1 or /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    session[:order_params] ||= {}

    @order = current_user.orders.build(session[:order_params])
    @price_list_items = current_user.price_list_items.includes(:product)
    # preload product images:
    @products = @price_list_items.includes(:product).map(&:product)

    @price_list_items.each do |price_list_item|
      @order.order_items.build(
        product_id: price_list_item.product_id,
        unit_price: price_list_item.price
      )
    end
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
    @order.total_amount = @order.order_items.sum(&:total_price)
    @order.shipping_address = order_params[:shipping_address].values.join(", ") if order_params[:shipping_address]
    @order.billing_address = order_params[:billing_address].values.join(", ") if order_params[:billing_address]

    if @order.valid?
      if @order.last_step?
        @order.save if @order.all_valid?
      else
        @order.next_step
      end
      session[:order_step] = @order.current_step
    end

    respond_to do |format|
      if @order.new_record?
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
    @order = current_user.orders.find(params[:id])
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
        shipping_address: %i[street_number_and_name post_town postcode additional_notes],
        billing_address: %i[street_number_and_name post_town postcode],
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
end
