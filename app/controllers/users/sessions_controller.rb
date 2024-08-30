class Users::SessionsController < Devise::SessionsController
  respond_to :json

  def create
    super do |resource|
      if resource.admin?
        # Assuming we have a method to generate a token, like Devise's 'sign_in'
        token = current_token(resource)

        if resource.persisted?
          # Return JSON response for admin login success
          return render json: { message: 'Welcome, Admin!', admin: true, token: token }, status: :ok
        else
          # Return JSON response for admin login failure
          return render json: { error: 'Invalid email or password.' }, status: :unauthorized
        end
      end
    end
  end

  protected

  def after_sign_in_path_for(resource)
    if resource.admin?
      admin_dashboard_path
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
        message: 'Signed in successfully.',
        admin: resource.admin?,
        token: token
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
