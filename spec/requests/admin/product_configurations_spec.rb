require 'rails_helper'

RSpec.describe "Admin::ProductConfigurations", type: :request do
  include Devise::Test::IntegrationHelpers

  let!(:admin_user) { User.create!(email: 'admin@example.com', password: 'password', role: 0) }
  let!(:product) { Product.create!(name: 'Test Product', product_type: 'Bike', base_price: 100.00) }
  let!(:part) { Part.create!(name: 'Frame', product_type: 'Bike') }
  let!(:option) { Option.create!(name: 'Full Suspension', part: part, price: 130.00, is_in_stock: true) }

  before do
    sign_in admin_user
  end

  describe "POST /admin/products/:product_id/product_configurations/bulk_create" do
    context 'with valid configurations' do
      let(:valid_configurations) do
        [
          { part_id: part.id, option_id: option.id }
        ]
      end

      it 'creates new product configurations' do
        post "/admin/products/#{product.id}/product_configurations/bulk_create", params: { configurations: valid_configurations }
        
        expect(response).to have_http_status(:created)
        expect(response.content_type).to include('application/json')
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('Product configurations created successfully.')
      end
    end

    context 'with duplicate configurations' do
      before do
        ProductConfiguration.create!(product: product, option: option)
      end

      let(:duplicate_configurations) do
        [
          { part_id: part.id, option_id: option.id }
        ]
      end

      it 'returns an unprocessable entity status' do
        post "/admin/products/#{product.id}/product_configurations/bulk_create", params: { configurations: duplicate_configurations }

        expect(response.status).to eq(422)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/json')
        json_response = JSON.parse(response.body)
        expect(json_response).to eq({"error"=>nil, "details"=>[]} )
      end
      
    end

    context 'with invalid configurations' do
      let(:invalid_configurations) do
        [
          { part_id: nil, option_id: nil }
        ]
      end

      it 'returns an error message with details' do
        post "/admin/products/#{product.id}/product_configurations/bulk_create", params: { configurations: invalid_configurations }
        
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/json')
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('Failed to create product configurations.')
      end
    end
  end
end
