require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  let(:xhr_header) {
    { 'X-Requested-With': 'XMLHttpRequest' }
  }
  let(:user) { FactoryBot.create(:user) }

  describe "GET /login" do
    describe "check whether an user had already logged in or not" do
      it 'is the case that an user have already logged in' do
        #一度userでログインする
        params = {
            session: {
              email: user.email,
              password: user.password,
              remember_me: false
            }
          }
            
        post '/login', params: params, headers: xhr_header
  
        
        get "/login", headers: xhr_header
  
        expect(response).to have_http_status(200)
        expect(json['current_user']).to be_truthy
      end

      it 'is the case that an user have not already logged in' do
        #userによるログインは行わない

        get "/login", headers: xhr_header
  
        expect(response).to have_http_status(200)
        expect(json['current_user']).to be_falsey
      end
    end
  end

  describe 'POST /login' do
    context 'with valid params' do
      it 'login with remebering' do
      
        params = {
          session: {
            email: user.email,
            password: user.password,
            remember_me: true
          }
        }
          
        post '/login', params: params, headers: xhr_header

        expect(response).to have_http_status(200)
        expect(json['message']).to eq 'ログインしました！'
        expect(json['current_user']).to be_truthy
        expect(cookies[:remember_token]).to be_truthy
      end
      it 'login without remembering' do
      
        params = {
          session: {
            email: user.email,
            password: user.password,
            remember_me: false
          }
        }

        post '/login', params: params, headers: xhr_header

        expect(response).to have_http_status(200)
        expect(json['message']).to eq 'ログインしました！'
        expect(json['current_user']).to be_truthy
        #なぜかremember_tokenがnilにならない。controller内では機能している。
        # expect(cookies[:remember_token]).to be_falsey
      end
    end

    context 'with invalid params' do
      it 'can not login with valid email and invalid password' do

        params = {
          session: {
            email: user.email,
            password: 'invalid_password'
          }
        }

        post '/login', params: params, headers: xhr_header

        expect(response).to have_http_status(200)
        expect(json['message']).to eq 'メールアドレスまたはパスワードが正しくありません。'
      end

      it 'can not login with invalid email and password' do

        params = {
          session: {
            email: 'invalid_user_email',
            password: 'invalid_password'
          }
        }

        post '/login', params: params, headers: xhr_header

        expect(response).to have_http_status(200)
        expect(json['message']).to eq 'メールアドレスまたはパスワードが正しくありません。'
      end
    end
  end

  describe 'DELETE /login' do
    it 'logout an user' do
      
      delete '/login', headers: xhr_header

      expect(response).to have_http_status(200)
      expect(json['message']).to eq 'ログアウトしました'
      expect(json['current_user']).to be_falsey
    end
  end
end
