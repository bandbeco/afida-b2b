# frozen_string_literal: true

module Admin
  class AddressesController < ApplicationController
    before_action :authenticate_user!
    before_action :require_admin!
    before_action :set_user
    before_action :set_address, only: %i[show edit update destroy]

    # GET /admin/users/:user_id/addresses
    def index
      @addresses = @user.addresses.order(created_at: :desc)
    end

    # GET /admin/users/:user_id/addresses/:id
    def show
      # @address is set by before_action
    end

    # GET /admin/users/:user_id/addresses/new
    def new
      @address = @user.addresses.build
    end

    # GET /admin/users/:user_id/addresses/:id/edit
    def edit
      # @address is set by before_action
    end

    # POST /admin/users/:user_id/addresses
    def create
      @address = @user.addresses.build(address_params)

      respond_to do |format|
        if @address.save
          # Set default addresses if this is the user's first address
          @user.update(default_shipping_address: @address, default_billing_address: @address) if @user.addresses.one?
          format.html { redirect_to admin_user_addresses_path(@user), notice: "Address was successfully created." }
          format.json { render :show, status: :created, location: admin_user_address_path(@user, @address) }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @address.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /admin/users/:user_id/addresses/:id
    def update
      respond_to do |format|
        if @address.update(address_params)
          format.html { redirect_to admin_user_addresses_path(@user), notice: "Address was successfully updated." }
          format.json { render :show, status: :ok, location: admin_user_address_path(@user, @address) }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @address.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /admin/users/:user_id/addresses/:id
    def destroy
      # Reset default addresses if the destroyed address was a default
      @user.update(default_shipping_address: nil) if @user.default_shipping_address_id == @address.id
      @user.update(default_billing_address: nil) if @user.default_billing_address_id == @address.id

      @address.destroy

      respond_to do |format|
        format.html { redirect_to admin_user_addresses_path(@user), notice: "Address was successfully destroyed." }
        format.json { head :no_content }
      end
    end

    private

    def require_admin!
      redirect_to root_path, alert: "You are not authorized to perform this action." unless current_user.admin?
    end

    def set_user
      @user = User.find(params[:user_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to admin_users_path, alert: "User not found."
    end

    def set_address
      @address = @user.addresses.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to admin_user_addresses_path(@user), alert: "Address not found."
    end

    # Use the same permitted parameters as the regular controller
    def address_params
      params.expect(
        address: %i[company
                    attn
                    building_name
                    street_number_and_name
                    post_town
                    postcode
                    additional_notes]
      )
    end
  end
end
