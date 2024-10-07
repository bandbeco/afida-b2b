class ShoppingCartItemsController < ApplicationController
  before_action :set_shopping_cart_item, only: %i[ show edit update destroy add_to_cart ]

  # GET /shopping_cart_items or /shopping_cart_items.json
  def index
    @order = current_user.orders.build
    @shopping_cart = current_user.shopping_cart || current_user.create_shopping_cart

    @shopping_cart_items = begin
      current_user.price_list_items.without_hidden.map do |item|
        @shopping_cart.shopping_cart_items.find_or_create_by(
          shopping_cart_id: @shopping_cart.id,
          product_id: item.product_id,
          unit_price: item.price
        )
      end
    end
  end

  # GET /shopping_cart_items/1 or /shopping_cart_items/1.json
  def show
  end

  def add_to_cart
    @shopping_cart_item.quantity += 1
    @shopping_cart_item.save
  end

  def remove_from_cart
    @shopping_cart_item.quantity = [@shopping_cart_item.quantity - 1, 0].max
    @shopping_cart_item.save
  end

  # GET /shopping_cart_items/new
  def new
    @shopping_cart_item = ShoppingCartItem.new
  end

  # GET /shopping_cart_items/1/edit
  def edit
  end

  # POST /shopping_cart_items or /shopping_cart_items.json
  def create
    @shopping_cart_item = current_user.shopping_cart.shopping_cart_items.build(shopping_cart_item_params)

    respond_to do |format|
      if @shopping_cart_item.save
        format.html { redirect_to shopping_cart_item_url(@shopping_cart_item), notice: "Shopping cart item was successfully created." }
        format.json { render :show, status: :created, location: @shopping_cart_item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @shopping_cart_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /shopping_cart_items/1 or /shopping_cart_items/1.json
  def update
    respond_to do |format|
      if @shopping_cart_item.update(shopping_cart_item_params)
        format.html { redirect_to shopping_cart_item_url(@shopping_cart_item), notice: "Shopping cart item was successfully updated." }
        format.json { render :show, status: :ok, location: @shopping_cart_item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @shopping_cart_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shopping_cart_items/1 or /shopping_cart_items/1.json
  def destroy
    @shopping_cart_item.destroy!

    respond_to do |format|
      format.html { redirect_to shopping_cart_items_url, notice: "Shopping cart item was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shopping_cart_item
      @shopping_cart_item = current_user.shopping_cart_items.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def shopping_cart_item_params
      params.require(:shopping_cart_item).permit(:shopping_cart_id, :product_id, :quantity)
    end
end
