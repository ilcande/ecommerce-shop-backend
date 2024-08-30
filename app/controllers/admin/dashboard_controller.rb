module Admin
  class DashboardController < Admin::BaseController
    def index
      # Fetch necessary data for the admin dashboard
      render json: { message: 'Welcome to the admin dashboard' }
    end
  end
end
