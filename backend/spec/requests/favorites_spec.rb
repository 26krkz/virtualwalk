require 'rails_helper'

RSpec.describe "Favorites", type: :request do
  let(:xhr_header) {
    { 'X-Requested-With': 'XMLHttpRequest' }
  }
  let(:user) { FactoryBot.create(:user) }
  let(:video) { FactoryBot.create(:video) }
  #一度userでログインする
  before do
    params = {
      session: {
        email: user.email,
        password: user.password,
        remember_me: false
      }
    }
      
    post '/login', params: params, headers: xhr_header
  end

  describe "POST /favorites" do
    it "add in user favorite list" do
      params = {
        user_id: json['current_user']['id'],
        video_id: video.id
      }

      expect{
        post '/favorite', params: params, headers: xhr_header
      }.to change(Favorite, :count).by(+1)
      expect(response).to have_http_status(200)
      expect(json['message']).to eq 'お気に入りに追加しました！'
      
    end
  end
  describe "DELETE /favorites" do
    it "remove from user favorite list" do
      params = {
         user_id: json['current_user']['id'],
         video_id: video.id
      }

      # 一度paramsで渡す情報でfavorite tableに追加する(お気に入り追加)
      post '/favorite', params: params, headers: xhr_header
      
      # favorite tableに追加した情報を削除する(お気に入り削除)
      expect{
        delete '/favorite', params: params, headers: xhr_header
      }.to change(Favorite, :count).by(-1)
      expect(response).to have_http_status(200)
      expect(json['message']).to eq 'お気に入りから削除しました'

    end
  end
  describe "GET /favorites" do
    it "get the best five videos which are most addded in favorite list" do
      params = {
        user_id: json['current_user']['id'],
        video_id: video.id
      }

      # 一度paramsで渡す情報でfavorite tableに追加する(お気に入り追加)
      post '/favorite', params: params, headers: xhr_header

      get '/favorite', headers: xhr_header

      expect(response).to have_http_status(200)
      expect(json).to be_truthy

    end
  end
end
