require 'rails_helper'

RSpec.describe "Pages", type: :request do
  describe "GET /" do
    it "returns http success" do
      get "/"
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Hello World")
    end
  end

  describe "GET /health" do
    it "returns http success and JSON status" do
      get "/health"
      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json["status"]).to eq("OK")
    end
  end

  describe "GET /version" do
    it "returns http success and version" do
      get "/version"
      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json["version"]).to eq("2.0.0")
    end
  end
end
