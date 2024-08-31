module Admin
  class ProductConfigurationsController < ApplicationController
    before_action :set_product

    def bulk_create
      # Ensure configurations come through as expected, only permitting option_id
      configurations = params.require(:configurations).map do |config|
        config.permit(:option_id) # Only need option_id since part_id is not relevant here
      end

      # Build the configurations to be saved
      new_configurations = configurations.map do |config|
        @product.product_configurations.new(option_id: config[:option_id])
      end

      if new_configurations.all?(&:valid?)
        # Save all configurations in a single transaction
        ActiveRecord::Base.transaction do
          new_configurations.each(&:save!)
        end
        render json: { message: 'Product configurations created successfully.' }, status: :created
      else
        render json: { error: 'Failed to create product configurations.', details: new_configurations.map(&:errors) }, status: :unprocessable_entity
      end
    end

    private

    def set_product
      @product = Product.find(params[:product_id])
    end
  end
end
