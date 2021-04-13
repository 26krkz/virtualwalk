require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:xhr_header) {
    { 'X-Requested-With': 'XMLHttpRequest' }
  }
  let(:user) { FactoryBot.create(:user) }

  describe 'POST /users' do
    context 'with valid params' do
      it 'creates new user' do

        params = {
          user: {
            name: '新規ユーザー',
            email: 'newuser@example.com',
            password: 'foobar',
            password_confirmation: 'foobar'
          }
        }

        expect {
          post "/users", params: params, headers: xhr_header
        }.to change(User, :count).by(+1)

        expect(response).to have_http_status(200)
        expect(json['message']).to eq '登録が完了しました！'
        expect(json['current_user']).to be_truthy
      end
    end

    context 'with invalid params' do
      it 'does not create new user' do

        params = {
          user: {
            name: ' ',
            email: 'user@invalid',
            password: 'short',
            password_confirmation: 'short'
          }
        }

        expect {
          post "/users", params: params, headers: xhr_header
        }.to change(User, :count).by(0)

        expect(response).to have_http_status(200)
        expect(json['error']).to be_truthy
        expect(json['current_user']).to be_falsey
      end
    end
  end

  describe 'PATCH /users/:id' do
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

    context 'with valid params' do
      it 'updates a user' do

        params = {
          user: {
            name: '変更したユーザー',
            email: 'updateuser@example.com',
            password: 'updatefoobar',
            password_confirmation: 'updatefoobar'
          }
        }
        patch "/users/#{user.id}", params: params, headers: xhr_header

        expect(response).to have_http_status(200)
        expect(json['message']).to eq 'プロフィールを変更しました！'
        expect(json['current_user']).to be_truthy
      end
    end

    context 'with invalid params' do
      it 'does not update a user' do
        
        params = {
          user: {
            name: '文字数が多い有効でないユーザー名',
            email: 'updateuser@invalid',
            password: 'short',
            password_confirmation: 'short'
          }
        }

        patch "/users/#{user.id}", params: params, headers: xhr_header

        expect(response).to have_http_status(200)
        expect(json['error']).to be_truthy
        expect(json['current_user']).to be_falsey
      end
    end
  end

  describe 'DELETE /users/:id' do
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

    it 'delete a user' do
      expect {
        delete "/users/#{user.id}",
        headers: xhr_header
      }.to change(User, :count).by(-1)

      expect(response).to have_http_status(200)
      expect(json['message']).to eq '退会しました'
      expect(json['current_user']).to be_falsey
    end
  end

  # describe 'GET /users/favorites' do
  #   it 'get user favorites' do
  #   end
  # end

  describe 'GET /users/guest' do
    it 'create a guest user and login' do

      expect {
        get "/users/guest",
        headers: xhr_header
    }.to change(User, :count).by(+1)
      expect(response).to have_http_status(200)
      expect(json['message']).to eq 'ゲストユーザーでログインしました！'
      expect(json['current_user']).to be_truthy
    end
  end
end
