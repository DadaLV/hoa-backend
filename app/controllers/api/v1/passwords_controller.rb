class Api::V1::PasswordsController < DeviseTokenAuth::PasswordsController

  def edit
     @resource = resource_class.with_reset_password_token(resource_params[:reset_password_token])

     if @resource && @resource.reset_password_period_valid?
       super
    else
      redirect_to "#{ENV['ROOT_FRONTEND_URL'] + 'login/expired?expired_link=recovery'}" and return
    end
  end

  def update
    
    if resource_params[:reset_password_token]
      @resource = resource_class.with_reset_password_token(resource_params[:reset_password_token])
      return render_update_error_unauthorized unless @resource
    else
      @resource = set_user_by_token
    end

    return render_update_error_unauthorized unless @resource

    unless @resource.provider == 'email'
      return render_update_error_password_not_required
    end

    unless password_resource_params[:password] && password_resource_params[:password_confirmation]
      return render_update_error_missing_password
    end

    if @resource.valid_password?(password_resource_params[:password])
      return render_update_error_current_password
    end

    if @resource.send(resource_update_method, password_resource_params)

      @resource.allow_password_change = false if recoverable_enabled?

      @resource.save!

      yield @resource if block_given?

      return render_update_success
    else
      return render_update_error
    end
  end

  protected

  def render_update_error_current_password
    return render json: { success: false, errors: [I18n.t("devise.passwords.same_as_current")] }, status: 422
  end
end