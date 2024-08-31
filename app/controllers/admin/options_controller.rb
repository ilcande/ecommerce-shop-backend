module Admin
  class OptionsController < ApplicationController
    before_action :set_option, only: [:show, :update, :destroy]

    # GET /options
    def index
      part = Part.find(params[:part_id])
      options = part.options
      render json: options
    end

    # GET /options/:id
    def show
      render json: @option
    end

    # POST /options
    def create
      @option = Option.new(option_params)
      if @option.save
        render json: @option, status: :created
      else
        render json: @option.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /options/:id
    def update
      if @option.update(option_params)
        render json: @option
      else
        render json: @option.errors, status: :unprocessable_entity
      end
    end

    # DELETE /options/:id
    def destroy
      @option.destroy
    end

    private

    def set_option
      @option = Option.find(params[:id])
    end

    def option_params
      params.require(:option).permit(:part_id, :name, :price, :is_in_stock)
    end
  end
end
