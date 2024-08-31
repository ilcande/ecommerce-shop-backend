module Admin
  class PartsController < ApplicationController
    before_action :set_part, only: [:show, :update, :destroy]

    # GET /parts
    def index
      @parts = Part.all
      render json: @parts
    end

    # GET /parts/:id
    def show
      render json: @part, include: :options
    end

    # POST /parts
    def create
      @part = Part.new(part_params)
      if @part.save
        render json: @part, status: :created
      else
        render json: @part.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /parts/:id
    def update
      if @part.update(part_params)
        render json: @part
      else
        render json: @part.errors, status: :unprocessable_entity
      end
    end

    # DELETE /parts/:id
    def destroy
      @part.destroy
    end

    private

    def set_part
      @part = Part.find(params[:id])
    end

    def part_params
      params.require(:part).permit(:name, :product_type)
    end
  end
end
