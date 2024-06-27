class PriceListItemsController < ApplicationController
  before_action :set_price_list_item, only: %i[ show edit update ]

  # GET /price_list_items or /price_list_items.json
  def index
    @price_list_items = current_user.price_list_items
  end

  # GET /price_list_items/1 or /price_list_items/1.json
  def show
  end

  # GET /price_list_items/1/edit
  def edit
  end

  # PATCH/PUT /price_list_items/1 or /price_list_items/1.json
  def update
    respond_to do |format|
      if @price_list_item.update(price_list_item_params)
        format.html { redirect_to price_list_item_url(@price_list_item), notice: "Price list item was successfully updated." }
        format.json { render :show, status: :ok, location: @price_list_item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @price_list_item.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_price_list_item
      @price_list_item = current_user.price_list_items.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def price_list_item_params
      params.require(:price_list_item).permit(:user_id, :product_id, :price)
    end
end
