class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :update, :destroy, :check_constraints_and_update_price]

  # GET /products
  def index
    @products = Product.all.includes(:options)
    render json: @products.to_json(include: {
      options: {
        include: {
          part: { include: { constraints: { include: [:constraint_part, :constraint_option] } } }
        }
      }
    })
  end

  # GET /products/:id
  def show
    render json: @product.to_json(include: {
      options: {
        include: {
          part: { include: { constraints: { include: [:constraint_part, :constraint_option] } } }
        }
      }
    })
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
  end

  # Custom action to handle constraints and dynamic pricing - TODO refactor/move
  # POST /products/:id/check_constraints_and_update_price
  def check_constraints_and_update_price
    selected_options = params[:selected_options] || {}

    available_options, price = calculate_available_options_and_price(selected_options)

    render json: { available_options: available_options, price: price }
  end

  private

  def set_product
    @product = Product.includes(options: { part: :constraints }).find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :product_type, :base_price, :image_url)
  end

  # Helper method to calculate available options and price based on selected options
  # TODO: Refactor this method to a service object
  def calculate_available_options_and_price(selected_options)
    available_options = {}
    price = @product.base_price

    @product.options.each do |option|
      part = option.part

      # Determine available options based on constraints
      available_options[part.id] ||= []
      available_options[part.id] << option if option_available?(option, selected_options)

      # Calculate price based on selected options
      selected_option_id = selected_options[part.id.to_s]
      if selected_option_id.present? && selected_option_id.to_i == option.id
        price += option.price

        # Apply any conditional pricing logic if required
        price += option.dependent_price if option.respond_to?(:dependent_price) && option.dependent_price.present?
      end
    end

    [available_options, price]
  end

  # Helper method to check if an option is available based on selected options
  # TODO: Refactor this method to a service object
  def option_available?(option, selected_options)
    option.constraints.none? do |constraint|
      constraint_part_id = constraint.constraint_part_id.to_s
      constraint_option_id = constraint.constraint_option_id.to_s

      selected_options[constraint_part_id] == constraint_option_id
    end
  end
end
