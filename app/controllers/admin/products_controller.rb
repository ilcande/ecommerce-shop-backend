module Admin
  class ProductsController < ApplicationController
    before_action :set_product, only: [:update, :destroy, :check_constraints_and_update_price]
    before_action :authenticate_user!, only: [:create, :update, :destroy, :new]  # Ensure user is authenticated for these actions
    before_action :authorize_admin!, only: [:create, :update, :destroy, :new]    # Ensure only admins can access these actions

    # GET /products/new
    def new
      # API-only endpoint to return new product form data
      render json: { message: "New product form data" }
    end

    # POST /products
    def create
      @product = Product.new(product_params)
      if @product.save
        render json: @product, status: :created
      else
        render json: @product.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /products/:id
    def update
      if @product.update(product_params)
        render json: @product
      else
        render json: @product.errors, status: :unprocessable_entity
      end
    end

    # DELETE /products/:id
    def destroy
      @product.destroy
      head :no_content
    end

    # Custom action to handle constraints and dynamic pricing - TODO refactor/move
    # POST /products/:id/check_constraints_and_update_price
    def check_constraints_and_update_price
      selected_options = params[:selected_options] || {}

      available_options, price = calculate_available_options_and_price(selected_options)

      render json: { available_options: available_options, price: price }
    end

    private

    def product_params
      params.require(:product).permit(:name, :product_type, :base_price, :image_url)
    end

    # Check if the user is an admin
    def authorize_admin!
      unless current_user && current_user.admin?
        render json: { error: "You are not authorized to perform this action." }, status: :forbidden
      end
    end
  end
end
