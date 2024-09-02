class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # Configure additional permitted parameters for Devise
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:role, :email, :password])
    devise_parameter_sanitizer.permit(:account_update, keys: [:role, :email, :password])
  end

  def authenticate_admin!
    unless current_user&.admin?
      render json: { error: 'You must be an admin to access this section' }, status: :unauthorized
    end
  end
end
