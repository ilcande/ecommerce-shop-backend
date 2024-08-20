require 'rails_helper'

RSpec.describe "Pages", type: :request do
  describe "GET /" do
    it "returns a success response with the welcome message" do
      get root_path

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq({ "message" => "Welcome to the E-commerce Shop API!" })
    end
  end

end
