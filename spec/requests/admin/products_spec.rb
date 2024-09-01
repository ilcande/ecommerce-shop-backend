require 'rails_helper'

RSpec.describe Admin::ProductsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let!(:admin_user) { User.create!(email: 'admin@example.com', password: 'password', role: :admin) }
  let!(:product) { Product.create!(name: 'Mountain Bike', product_type: 'Bike', base_price: 500.00, image_url: 'http://example.com/mountain_bike.jpg') }
  let(:valid_attributes) { { name: 'Road Bike', product_type: 'Bike', base_price: 700.00, image_url: 'http://example.com/road_bike.jpg' } }
  let(:invalid_attributes) { { name: '', product_type: '', base_price: nil, image_url: '' } }

  before do
    sign_in admin_user
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new product' do
        expect {
          post :create, params: { product: valid_attributes }
        }.to change(Product, :count).by(1)
        expect(response).to have_http_status(:created)
        expect(response.content_type).to include('application/json')
        json_response = JSON.parse(response.body)
        expect(json_response['name']).to eq('Road Bike')
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new product' do
        expect {
          post :create, params: { product: invalid_attributes }
        }.to change(Product, :count).by(0)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/json')
        json_response = JSON.parse(response.body)
        expect(json_response['name']).to include("can't be blank")
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'updates the product' do
        patch :update, params: { id: product.id, product: { name: 'Updated Bike' } }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
        json_response = JSON.parse(response.body)
        expect(json_response['name']).to eq('Updated Bike')
      end
    end

    context 'with invalid attributes' do
      it 'does not update the product' do
        patch :update, params: { id: product.id, product: { name: '' } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/json')
        json_response = JSON.parse(response.body)
        expect(json_response['name']).to include("can't be blank")
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the product' do
      expect {
        delete :destroy, params: { id: product.id }
      }.to change(Product, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
