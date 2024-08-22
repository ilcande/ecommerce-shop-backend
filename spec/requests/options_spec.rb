require 'rails_helper'

RSpec.describe OptionsController, type: :controller do
  let!(:part) { Part.create!(name: 'Frame', product_type: 'Bike') }
  let!(:option) { Option.create!(name: 'Full Suspension', part: part, price: 130.00, is_in_stock: true) }
  let(:valid_attributes) { { name: 'New Option', price: 150.00, is_in_stock: true, part_id: part.id } }
  let(:invalid_attributes) { { name: '', price: -10.00, is_in_stock: true } }

  describe 'GET #index' do
    it 'returns a list of options for a specific part' do
      get :index, params: { part_id: part.id }
      expect(response).to have_http_status(:success)
      expect(response.content_type).to include('application/json')
      expect(JSON.parse(response.body).size).to eq(1)
      expect(JSON.parse(response.body).first['name']).to eq('Full Suspension')
    end
  end

  describe 'GET #show' do
    it 'returns a specific option' do
      get :show, params: { id: option.id }
      expect(response).to have_http_status(:success)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response['name']).to eq('Full Suspension')
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new option' do
        expect {
          post :create, params: { part_id: part.id, option: valid_attributes }
        }.to change(Option, :count).by(1)
        expect(response).to have_http_status(:created)
        expect(response.content_type).to include('application/json')
        json_response = JSON.parse(response.body)
        expect(json_response['name']).to eq('New Option')
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new option' do
        expect {
          post :create, params: { part_id: part.id, option: invalid_attributes }
        }.to change(Option, :count).by(0)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/json')
        json_response = JSON.parse(response.body)
        expect(json_response['name']).to include("can't be blank")
        expect(json_response['price']).to include("must be greater than or equal to 0")
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'updates the option' do
        patch :update, params: { part_id: part.id, id: option.id, option: { name: 'Updated Option' } }
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['name']).to eq('Updated Option')
      end
    end

    context 'with invalid attributes' do
      it 'does not update the option' do
        patch :update, params: { part_id: part.id, id: option.id, option: { name: '', price: -20.00 } }
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['name']).to include("can't be blank")
        expect(json_response['price']).to include("must be greater than or equal to 0")
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the option' do
      expect {
        delete :destroy, params: { part_id: part.id, id: option.id }
      }.to change(Option, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
