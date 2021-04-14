require 'rails_helper'

RSpec.describe "Videos", type: :request do
  let(:xhr_header) {
    { 'X-Requested-With': 'XMLHttpRequest' }
  }
  let(:video) { FactoryBot.create(:video) }

  describe "GET /videos/:id" do
    it "get a video data" do
      get "/videos/#{video.video_id}", headers: xhr_header
      expect(response).to have_http_status(200)
      expect(json).to be_truthy
    end
  end

  describe "GET /videos" do
    it "get some video data" do

      params = {
        region: video.region
      }

      get "/videos", params: params, headers: xhr_header
      expect(response).to have_http_status(200)
      expect(json).to be_truthy
    end
  end
end
