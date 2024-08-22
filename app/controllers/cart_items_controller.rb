class CartItemsController < ApplicationController
  before_action :set_cart_item, only: [:update, :destroy]

  # GET /cart_items
  def index
    @cart_items = CartItem.includes(:product).all
    render json: @cart_items, include: :product
  end

  # POST /cart_items
  def create
    @cart_item = CartItem.new(cart_item_params)
    if @cart_item.save
      render json: @cart_item, status: :created
    else
      render json: @cart_item.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /cart_items/:id
  def update
    if @cart_item.update(cart_item_params)
      render json: @cart_item
    else
      render json: @cart_item.errors, status: :unprocessable_entity
    end
  end

  # DELETE /cart_items/:id
  def destroy
    @cart_item.destroy
    head :no_content
  end

  private

  def set_cart_item
    @cart_item = CartItem.find(params[:id])
  end

  def cart_item_params
    params.require(:cart_item).permit(:product_id, :quantity, selections: {})
  end
end
