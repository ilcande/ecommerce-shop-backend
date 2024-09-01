require 'rails_helper'

RSpec.describe Admin::ProductConfigurationService, type: :service do
  let!(:product) { Product.create!(name: 'Test Product', product_type: 'Bike', base_price: 100.00) }
  let!(:part) { Part.create!(name: 'Frame', product_type: 'Bike') }
  let!(:option) { Option.create!(name: 'Full Suspension', part: part, price: 130.00, is_in_stock: true) }

  # Define the service variable
  let(:service) { Admin::ProductConfigurationService.new(product, configurations) }

  describe '#bulk_create' do
    context 'when there are no existing configurations' do
      let(:configurations) do
        [
          { part_id: part.id, option_id: option.id }
        ]
      end

      it 'creates new product configurations' do
        result = service.bulk_create

        expect(result[:success]).to be(true)
        expect(result[:message]).to eq('Product configurations created successfully.')
        expect(product.product_configurations.count).to eq(1)
      end
    end

    context 'when configurations are duplicates' do
      before do
        ProductConfiguration.create!(product: product, option: option)
      end

      let(:configurations) do
        [
          { part_id: part.id, option_id: option.id }
        ]
      end

      it 'returns a message indicating no new configurations' do
        result = service.bulk_create

        expect(result[:success]).to be(false)
        expect(result[:message]).to eq('No new configurations to create. All provided configurations are duplicates.')
      end
    end

    context 'when saving configurations fails' do
      let(:invalid_configurations) do
        [
          { part_id: nil, option_id: nil }
        ]
      end

      let(:configurations) { invalid_configurations }

      it 'returns an error message with details' do
        result = service.bulk_create

        expect(result[:success]).to be(false)
        expect(result[:error]).to eq('Failed to create product configurations.')
      end
    end
  end
end
