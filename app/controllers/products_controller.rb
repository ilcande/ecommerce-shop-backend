class ProductsController < ApplicationController
  before_action :set_product, only: [:show]
  
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
          part: { only: [:id, :name] }  # Simplify part inclusion
        }
      }
    })
  end

  private

  def set_product
    @product = Product.includes(options: { part: :constraints }).find(params[:id])
  end
end
