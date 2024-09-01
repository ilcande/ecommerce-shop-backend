module Admin
  class ProductConfigurationsController < ApplicationController
    before_action :set_product

    def bulk_create
      configurations = params.require(:configurations).map do |config|
        config.permit(:part_id, :option_id)
      end

      service = Admin::ProductConfigurationService.new(product, configurations)
      result = service.bulk_create

      if result[:success]
        render json: { message: result[:message] }, status: :created
      else
        render json: { error: result[:error], details: result[:details] || [] }, status: :unprocessable_entity
      end
    end

    private

    attr_reader :product

    def set_product
      @product = Product.find(params[:product_id])
    end
  end
end
