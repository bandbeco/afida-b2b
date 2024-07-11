# frozen_string_literal: true

class Users::InvitationsController < Devise::InvitationsController

  def create
    redirect_to root_path, alert: "You are not authorised to perform this action" unless current_user.admin?
    user = User.find(invitation_params[:user_id])
    user.invite!(current_user)
    redirect_to users_path, notice: "Invitation sent"
  end

  def update
    Product.all.each do |product|
      user.price_list_items.create!(product: product, price: 1.00)
    end

    redirect_to users_path, notice: "You are now signed in"
  end

  protected

  def invitation_params
    params.require(:user).permit(:user_id)
  end
end
