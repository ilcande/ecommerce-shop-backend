class Users::SessionsController < Devise::SessionsController
  respond_to :json

  def create
    super
  end

  protected

  def after_sign_in_path_for(resource)
    if resource.admin?
      admin_dashboard_index_path
    else
      root_path
    end
  end

  # Override default devise methods that use flash messages
  def verify_signed_out_user
    if all_signed_out?
      render json: { message: 'Already signed out.' }, status: :ok
    else
      render json: { message: 'Signed out successfully.' }, status: :ok
    end
  end

  def respond_with(resource, _opts = {})
    if resource.persisted?
      token = current_token(resource) # Ensure token is generated
      render json: {
      status: 'success',
      message: 'Signed in successfully',
      token: token,
      admin: resource.admin?,
      user: resource.as_json(only: [:email]) # Never include the password
    }, status: :ok
    else
      render json: { error: 'Invalid email or password.' }, status: :unauthorized
    end
  end

  def respond_to_on_destroy
    render json: { message: 'Logged out successfully.' }, status: :ok
  end

  private

  # get the current token from devise token auth
  def current_token(user)
    request.env['warden-jwt_auth.token'] = sign_in(user, store: false)
  end
end
