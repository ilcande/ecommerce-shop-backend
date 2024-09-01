
module Admin
  class ProductConfigurationService
    def initialize(product, configurations)
      @product = product
      @configurations = configurations
    end

    def bulk_create
      existing_option_ids = product.product_configurations.pluck(:option_id)

      # Filter out configurations that are already present
      new_configurations = filter_new_configurations(existing_option_ids)

      return { success: false, message: 'No new configurations to create. All provided configurations are duplicates.' } if new_configurations.empty?

      # Validate and save configurations
      if save_configurations(new_configurations)
        { success: true, message: 'Product configurations created successfully.' }
      else
        { success: false, error: 'Failed to create product configurations.', details: new_configurations.map(&:errors) }
      end
    end

    private

    attr_reader :product, :configurations

    def filter_new_configurations(existing_option_ids)
      configurations.reject do |config|
        existing_option_ids.include?(config[:option_id].to_i)
      end.map do |config|
        product.product_configurations.new(option_id: config[:option_id])
      end
    end

    def save_configurations(configurations)
      ActiveRecord::Base.transaction do
        configurations.each(&:save!)
      end
      true
    rescue ActiveRecord::RecordInvalid
      false
    end
  end
end
