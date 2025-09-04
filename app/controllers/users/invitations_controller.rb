# frozen_string_literal: true

module Users
  class InvitationsController < Devise::InvitationsController
    def create
      redirect_to root_path, alert: 'You are not authorised to perform this action' unless current_user.admin?
      user = User.find(invitation_params[:user_id])
      user.invite!(current_user)
      redirect_to admin_users_path, notice: "Invitation sent to #{user.email}."
    end

    protected

    def invitation_params
      params.expect(user: [:user_id])
    end
  end
end
