# frozen_string_literal: true

class AddressesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_address, only: %i[edit update destroy set_default_shipping set_default_billing]

  def index
    @addresses = current_user.addresses.order(created_at: :desc)
    @default_shipping_address_id = current_user.default_shipping_address_id
    @default_billing_address_id = current_user.default_billing_address_id
  end

  def new
    @address = current_user.addresses.build
  end

  def create
    @address = current_user.addresses.build(address_params)

    respond_to do |format|
      if @address.save
        if current_user.addresses.count == 1
          current_user.update(default_shipping_address: @address, default_billing_address: @address)
        end
        format.html { redirect_to addresses_url, notice: 'Address was successfully created.' }
        format.json { render :show, status: :created, location: @address }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @address.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit; end

  def update
    respond_to do |format|
      if @address.update(address_params)
        format.html { redirect_to addresses_url, notice: 'Address was successfully updated.' }
        format.json { render :show, status: :ok, location: @address }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @address.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @address.destroy

    respond_to do |format|
      format.html { redirect_to addresses_url, notice: 'Address was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def set_default_shipping
    if current_user.update(default_shipping_address: @address)
      redirect_to addresses_url, notice: 'Default shipping address updated.'
    else
      redirect_to addresses_url, alert: 'Could not update default shipping address.'
    end
  end

  def set_default_billing
    if current_user.update(default_billing_address: @address)
      redirect_to addresses_url, notice: 'Default billing address updated.'
    else
      redirect_to addresses_url, alert: 'Could not update default billing address.'
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_address
    @address = current_user.addresses.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to addresses_url, alert: 'Address not found.'
  end

  # Only allow a list of trusted parameters through.
  def address_params
    params.require(:address).permit(
      :company,
      :attn,
      :building_name,
      :street_number_and_name,
      :post_town,
      :postcode,
      :additional_notes
    )
  end
end
