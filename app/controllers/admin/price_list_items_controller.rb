# frozen_string_literal: true

module Admin
  class PriceListItemsController < ApplicationController
    before_action :set_price_list_item, only: %i[show edit update]

    # GET /price_list_items or /price_list_items.json
    def index
      @user = User.find(params[:user_id])
      @price_list_items = @user
                          .price_list_items
                          .includes(:product)
    end

    # GET /price_list_items/1 or /price_list_items/1.json
    def show; end

    # GET /price_list_items/1/edit
    def edit; end

    # PATCH/PUT /price_list_items/1 or /price_list_items/1.json
    def update
      respond_to do |format|
        if @price_list_item.update(price_list_item_params)
          # Redirect back to the user's price list index after updating a single item
          format.html do
            redirect_to admin_user_price_list_items_url(@price_list_item.user),
                        notice: "Price list item was successfully updated."
          end
          format.json { render :show, status: :ok, location: admin_price_list_item_url(@price_list_item) }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @price_list_item.errors, status: :unprocessable_entity }
        end
      end
    end

    private

    def set_price_list_item
      @price_list_item = PriceListItem.find(params[:id])
    end

    def price_list_item_params
      params.expect(price_list_item: %i[user_id product_id price hidden])
    end
  end
end
