require 'rails_helper'

RSpec.describe Admin::ConstraintsController, type: :controller do
  # Include Devise test helpers for controller tests
  include Devise::Test::ControllerHelpers

  # Set up an admin user to be authenticated
  let!(:admin_user) { User.create!(email: 'admin@example.com', password: 'password', role: 0) }

  let!(:part) { Part.create!(name: 'Frame', product_type: 'Bike') }
  let!(:constraint_option) { Option.create!(name: 'Full Suspension', part: part, price: 130.00, is_in_stock: true) }
  let!(:constraint) do
    Constraint.create!(
      part_id: part.id,
      constraint_part_id: part.id,
      constraint_option_id: constraint_option.id,
      option_id: constraint_option.id
    )
  end

  let(:valid_attributes) do
    {
      part_id: part.id,
      constraint_part_id: part.id,
      constraint_option_id: constraint_option.id,
      option_id: constraint_option.id
    }
  end

  let(:invalid_attributes) do
    {
      part_id: nil,
      constraint_part_id: nil,
      constraint_option_id: nil,
      option_id: nil
    }
  end

  # Authenticate the admin user before each test
  before do
    sign_in admin_user
  end

  describe 'GET #show' do
    it 'returns a specific constraint' do
      get :show, params: { id: constraint.id }
      expect(response).to have_http_status(:success)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response['part_id']).to eq(part.id)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new constraint' do
        expect {
          post :create, params: { constraint: valid_attributes }
        }.to change(Constraint, :count).by(1)
        expect(response).to have_http_status(:created)
        expect(response.content_type).to include('application/json')
        json_response = JSON.parse(response.body)
        expect(json_response['part_id']).to eq(part.id)
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new constraint' do
        expect {
          post :create, params: { constraint: invalid_attributes }
        }.to change(Constraint, :count).by(0)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/json')

        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to have_key('part')
        expect(json_response['errors']).to have_key('constraint_part')
        expect(json_response['errors']).to have_key('constraint_option')
        expect(json_response['errors']['part']).to include("can't be blank")
        expect(json_response['errors']['constraint_part']).to include("can't be blank")
        expect(json_response['errors']['constraint_option']).to include("can't be blank")
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'updates the constraint' do
        patch :update, params: { id: constraint.id, constraint: { part_id: part.id } }
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['part_id']).to eq(part.id)
      end
    end

    context 'with invalid attributes' do
      it 'does not update the constraint' do
        patch :update, params: { id: constraint.id, constraint: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)

        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to have_key('part')
        expect(json_response['errors']).to have_key('constraint_part')
        expect(json_response['errors']).to have_key('constraint_option')
        expect(json_response['errors']['part']).to include("can't be blank")
        expect(json_response['errors']['constraint_part']).to include("can't be blank")
        expect(json_response['errors']['constraint_option']).to include("can't be blank")
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the constraint' do
      expect {
        delete :destroy, params: { id: constraint.id }
      }.to change(Constraint, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
