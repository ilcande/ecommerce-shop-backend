module Admin
  class StockLevelsController < ApplicationController
    # GET /stock_levels
    def index
      @stock_levels = StockLevel.includes(:option).all
      render json: @stock_levels, include: :option
    end

    # GET /stock_levels/:id
    def show
      @stock_level = StockLevel.find(params[:id])
      render json: @stock_level, include: :option
    end

    # POST /stock_levels
    def create
      @stock_level = StockLevel.new(stock_level_params)
      if @stock_level.save
        render json: @stock_level, status: :created
      else
        render json: @stock_level.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /stock_levels/:id
    def update
      @stock_level = StockLevel.find(params[:id])
      if @stock_level.update(stock_level_params)
        render json: @stock_level, status: :ok
      else
        render json: @stock_level.errors, status: :unprocessable_entity
      end
    end

    private

    def stock_level_params
      params.require(:stock_level).permit(:option_id, :quantity, :is_in_stock)
    end
  end
end
