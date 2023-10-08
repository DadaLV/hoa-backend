class Api::V1::InvitationsController < Devise::InvitationsController
  include InvitableMethods
  before_action :authenticate_user!, only: :create
  before_action :resource_from_invitation_token, only: [:edit, :update]

  def create
    invitation = User.invite!(invite_params, current_api_v1_user)

    if invitation.errors.empty?
      render json: { success: [I18n.t("devise.api.invitations.invitation_sent"), invitation_sent_at: invitation.invitation_sent_at] }, status: :created
    else
      render json: { errors: invitation.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def edit
    user = User.find_by_invitation_token(params[:invitation_token], true)

    if user
      redirect_to "#{ENV['ROOT_FRONTEND_URL'] + 'login/create-new-password'}?invitation_token=#{params[:invitation_token]}"
    else
      redirect_to "#{ENV['ROOT_FRONTEND_URL'] + 'login/expired'}"
    end
  end

  def update
    user = User.accept_invitation!(accept_invitation_params)
    if user.errors.empty?
      render json: { success: [I18n.t("devise.api.invitations.user_updated")] }, status: :accepted
    else
      render json: { errors: user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  private

  def invite_params
    params.require(:user).permit(:email, :invitation_token, :provider, :skip_invitation, :role, :first_name, :middle_name, :last_name, :phone_number, :date_of_birth, :address, :avatar)
  end

  def accept_invitation_params
    params.permit(:password, :password_confirmation, :invitation_token)
  end
end