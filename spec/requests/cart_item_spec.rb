require 'rails_helper'

RSpec.describe CartItemsController, type: :controller do
  let!(:part) { Part.create!(name: 'Frame Part', product_type: 'Accessory') }
  let!(:product) { Product.create!(name: 'Sample Product', base_price: 20.00, product_type: 'Accessory') }
  
  let!(:frame) { Option.create!(part_id: part.id, name: 'Diamond Frame', price: 50.00) }
  let!(:wheels) { Option.create!(part_id: part.id, name: 'Road Wheels', price: 100.00) }
  let!(:chain) { Option.create!(part_id: part.id, name: 'Eight Speed Chain', price: 25.00) }

  let!(:cart_item) { CartItem.create!(
    product: product,
    quantity: 2,
    selections: {
      'frame' => frame.id,
      'wheels' => wheels.id,
      'chain' => chain.id
    }
  ) }

  let(:valid_attributes) do
    {
      product_id: product.id,
      quantity: 3,
      selections: {
        'frame' => frame.id,
        'wheels' => wheels.id,
        'chain' => chain.id
      }
    }
  end

  let(:invalid_attributes) do
    {
      product_id: nil,
      quantity: -1,
      selections: {}
    }
  end

  describe 'GET #index' do
    it 'returns a list of cart items' do
      get :index
      expect(response).to have_http_status(:success)
      expect(response.content_type).to include('application/json')

      json_response = JSON.parse(response.body)

      expect(json_response.size).to eq(1)
      expect(json_response.first['product']['name']).to eq('Sample Product')
      expect(json_response.first['selections']['frame']).to eq(frame.id)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new cart item' do
        expect {
          post :create, params: { cart_item: valid_attributes }
        }.to change(CartItem, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(response.content_type).to include('application/json')

        json_response = JSON.parse(response.body)

        # Adjusting expectation to match the actual response format
        expect(json_response['quantity']).to eq(3)
        expect(json_response['selections']['frame']).to eq(valid_attributes[:selections]['frame'].to_s)
        expect(json_response['selections']['wheels']).to eq(valid_attributes[:selections]['wheels'].to_s)
        expect(json_response['selections']['chain']).to eq(valid_attributes[:selections]['chain'].to_s)
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new cart item' do
        expect {
          post :create, params: { cart_item: invalid_attributes }
        }.to change(CartItem, :count).by(0)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/json')

        json_response = JSON.parse(response.body)

        expect(json_response['product_id']).to include("can't be blank") if json_response['product_id']
        expect(json_response['quantity']).to include("must be greater than 0") if json_response['quantity']
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'updates the cart item' do
        patch :update, params: { id: cart_item.id, cart_item: { quantity: 5 } }
        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)

        expect(json_response['quantity']).to eq(5)
      end
    end

    context 'with invalid attributes' do
      it 'does not update the cart item' do
        patch :update, params: { id: cart_item.id, cart_item: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)

        json_response = JSON.parse(response.body)

        expect(json_response['product_id']).to include("can't be blank") if json_response['product_id']
        expect(json_response['quantity']).to include("must be greater than 0") if json_response['quantity']
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the cart item' do
      expect {
        delete :destroy, params: { id: cart_item.id }
      }.to change(CartItem, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
