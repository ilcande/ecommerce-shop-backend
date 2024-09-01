module Admin
  class ProductConfigurationsController < ApplicationController
    before_action :set_product

    def bulk_create
      configurations = params.require(:configurations).map do |config|
        config.permit(:part_id, :option_id)
      end

      # Check for existing configurations to avoid duplicates
      existing_option_ids = @product.product_configurations.pluck(:option_id)

      # Filter out configurations that are already present
      new_configurations = configurations.reject do |config|
        existing_option_ids.include?(config[:option_id].to_i)
      end.map do |config|
        @product.product_configurations.new(option_id: config[:option_id])
      end

      if new_configurations.empty?
        render json: { message: 'No new configurations to create. All provided configurations are duplicates.' }, status: :unprocessable_entity
      else
        # Validate the configurations
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
    end

    private

    def set_product
      @product = Product.find(params[:product_id])
    end
  end
end
