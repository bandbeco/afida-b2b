# frozen_string_literal: true

class Users::InvitationsController < Devise::InvitationsController

  def create
    redirect_to root_path, alert: "You are not authorised to perform this action" unless current_user.admin?
    user = User.find(invitation_params[:user_id])
    user.invite!(current_user)
    redirect_to users_path, notice: "Invitation sent"
  end

  protected

  def invitation_params
    params.require(:user).permit(:user_id)
  end
end
