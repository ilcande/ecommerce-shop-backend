class PriceModifiersController < ApplicationController
  before_action :set_price_modifier, only: [:show, :update, :destroy]

  # GET /price_modifiers
  def index
    @price_modifiers = PriceModifier.all
    render json: @price_modifiers
  end

  # GET /price_modifiers/:id
  def show
    render json: @price_modifier, include: :price_modifier_conditions
  end

  # POST /price_modifiers
  def create
    @price_modifier = PriceModifier.new(price_modifier_params)
    if @price_modifier.save
      render json: @price_modifier, status: :created
    else
      render json: @price_modifier.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /price_modifiers/:id
  def update
    if @price_modifier.update(price_modifier_params)
      render json: @price_modifier
    else
      render json: @price_modifier.errors, status: :unprocessable_entity
    end
  end

  # DELETE /price_modifiers/:id
  def destroy
    @price_modifier.destroy
  end

  private

  def set_price_modifier
    @price_modifier = PriceModifier.find(params[:id])
  end

  def price_modifier_params
    params.require(:price_modifier).permit(:product_id, :modifier_amount, :description, 
                                           price_modifier_conditions_attributes: [:option_id])
  end
end
