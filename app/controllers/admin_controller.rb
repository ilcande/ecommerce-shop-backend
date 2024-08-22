# app/controllers/admin_controller.rb
class AdminController < ApplicationController
  # POST /admin/add_product
  def add_product
    product = Product.new(product_params)
    if product.save
      render json: product, status: :created
    else
      render json: product.errors, status: :unprocessable_entity
    end
  end

  # POST /admin/add_part
  def add_part
    part = Part.new(part_params)
    if part.save
      render json: part, status: :created
    else
      render json: part.errors, status: :unprocessable_entity
    end
  end

  # POST /admin/add_option
  def add_option
    option = Option.new(option_params)
    if option.save
      render json: option, status: :created
    else
      render json: option.errors, status: :unprocessable_entity
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :product_type, :base_price, :image_url)
  end

  def part_params
    params.require(:part).permit(:name, :product_type)
  end

  def option_params
    params.require(:option).permit(:part_id, :name, :price, :is_in_stock)
  end
end
