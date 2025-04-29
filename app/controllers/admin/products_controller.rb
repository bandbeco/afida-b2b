class Admin::ProductsController < ApplicationController
  before_action :set_product, only: [:show, :update_visibility]

  def show
    @price_list_items = @product.price_list_items.includes(:user)
  end

  def update_visibility
    # When using the bulk action buttons
    if params[:visibility].present?
      visibility = params[:visibility] == 'true'
      
      ActiveRecord::Base.transaction do
        if params[:user_ids].present?
          # Update visibility only for selected users
          @product.price_list_items
            .where(user_id: params[:user_ids])
            .update_all(hidden: !visibility)
          
          redirect_to admin_product_path(@product), notice: "Product visibility was updated for selected users."
        else
          # Update visibility for all users
          @product.price_list_items.update_all(hidden: !visibility)
          
          redirect_to admin_product_path(@product), notice: "Product visibility was successfully updated for all users."
        end
      end
    # When using the individual visibility form
    elsif params[:visible_user_ids].present?
      ActiveRecord::Base.transaction do
        # First, hide the product for all users
        @product.price_list_items.update_all(hidden: true)
        
        # Then, make it visible for selected users
        @product.price_list_items
          .where(user_id: params[:visible_user_ids])
          .update_all(hidden: false)
        
        redirect_to admin_product_path(@product), notice: "Product visibility settings were successfully updated."
      end
    else
      # If no users were selected in the individual form, hide for all
      @product.price_list_items.update_all(hidden: true)
      redirect_to admin_product_path(@product), notice: "Product has been hidden for all users."
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end
end 