require 'rails_helper'

RSpec.describe PartsController, type: :controller do
  let!(:part) { Part.create!(name: 'Frame', product_type: 'Bike') }
  let(:valid_attributes) { { name: 'Wheels', product_type: 'Bike' } }
  let(:invalid_attributes) { { name: '', product_type: '' } }

  describe 'GET #index' do
    it 'returns a list of parts' do
      get :index
      expect(response).to have_http_status(:success)
      expect(response.content_type).to include('application/json')
      expect(JSON.parse(response.body).size).to eq(1)
      expect(JSON.parse(response.body).first['name']).to eq('Frame')
    end
  end

  describe 'GET #show' do
    it 'returns a specific part with its options' do
      # Create an option associated with the part
      option = Option.create!(name: 'Full Suspension', part: part, price: 130.00, is_in_stock: true)
      
      get :show, params: { id: part.id }
      expect(response).to have_http_status(:success)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response['name']).to eq('Frame')
      expect(json_response['options'].first['name']).to eq('Full Suspension')
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new part' do
        expect {
          post :create, params: { part: valid_attributes }
        }.to change(Part, :count).by(1)
        expect(response).to have_http_status(:created)
        expect(response.content_type).to include('application/json')
        json_response = JSON.parse(response.body)
        expect(json_response['name']).to eq('Wheels')
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new part' do
        expect {
          post :create, params: { part: invalid_attributes }
        }.to change(Part, :count).by(0)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/json')
        json_response = JSON.parse(response.body)
        expect(json_response['name']).to include("can't be blank")
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'updates the part' do
        patch :update, params: { id: part.id, part: { name: 'Updated Frame' } }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
        json_response = JSON.parse(response.body)
        expect(json_response['name']).to eq('Updated Frame')
      end
    end

    context 'with invalid attributes' do
      it 'does not update the part' do
        patch :update, params: { id: part.id, part: { name: '' } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/json')
        json_response = JSON.parse(response.body)
        expect(json_response['name']).to include("can't be blank")
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the part' do
      expect {
        delete :destroy, params: { id: part.id }
      }.to change(Part, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
