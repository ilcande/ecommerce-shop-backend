require 'rails_helper'

RSpec.describe Admin::StockLevelsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let!(:admin_user) { User.create!(email: 'admin@example.com', password: 'password', role: :admin) }
  let!(:part) { Part.create!(name: 'Test Part', product_type: 'Bike') }  # Create a valid part
  let!(:option) { Option.create!(name: 'Test Option', part: part, price: 100.00, is_in_stock: true) }
  let!(:stock_level) { StockLevel.create!(option: option, quantity: 10, is_in_stock: true) }

  before do
    sign_in admin_user
  end

  describe 'GET #index' do
    it 'returns a list of stock levels' do
      get :index
      expect(response).to have_http_status(:success)
      expect(response.content_type).to include('application/json')
      expect(JSON.parse(response.body).size).to eq(1)
    end
  end

  describe 'GET #show' do
    it 'returns a specific stock level' do
      get :show, params: { id: stock_level.id }
      expect(response).to have_http_status(:success)
      expect(response.content_type).to include('application/json')
      expect(JSON.parse(response.body)['quantity']).to eq(10)
    end
  end

  describe 'POST #create' do
    let(:valid_attributes) { { option_id: option.id, quantity: 15, is_in_stock: true } }
    let(:invalid_attributes) { { option_id: nil, quantity: nil } }

    context 'with valid attributes' do
      it 'creates a new stock level' do
        expect {
          post :create, params: { stock_level: valid_attributes }
        }.to change(StockLevel, :count).by(1)
        expect(response).to have_http_status(:created)
        expect(response.content_type).to include('application/json')
        json_response = JSON.parse(response.body)
        expect(json_response['quantity']).to eq(15)
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new stock level' do
        expect {
          post :create, params: { stock_level: invalid_attributes }
        }.to change(StockLevel, :count).by(0)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH #update' do
    it 'updates the stock level' do
      patch :update, params: { id: stock_level.id, stock_level: { quantity: 20, is_in_stock: false } }
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('application/json')
      updated_stock_level = StockLevel.find(stock_level.id)
      expect(updated_stock_level.quantity).to eq(20)
      expect(updated_stock_level.is_in_stock).to be_falsey
    end

    it 'returns an error if update fails' do
      patch :update, params: { id: stock_level.id, stock_level: { quantity: nil } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
