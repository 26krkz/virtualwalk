require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  let(:xhr_header) {
    { 'X-Requested-With': 'XMLHttpRequest' }
  }
  let(:user) { FactoryBot.create(:user) }

  # before do
  #   allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  # end

  describe "GET /login" do
    it 'check an user already have logged in' do
      expect_any_instance_of(ApplicationController).to receive(:logged_in?)

      get "/login", headers: xhr_header

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      #要変更
      expect(response.body).to be_falsey
    end
  end

  describe 'POST /login' do
    context 'with valid params' do
      context 'login with valid email and password' do
        it 'login with remebering' do
          expect_any_instance_of(ApplicationController).to receive(:log_in).with(user)
        
          params = {
            session: {
              email: user.email,
              password: user.password,
              remember_me: true
            }
          }
            
          post '/login', params: params, headers: xhr_header
          # expect_any_instance_of(ApplicationController).to receive(:remember).with(user)
  
          expect(response).to have_http_status(200)
          json = JSON.parse(response.body)
          expect(json['message']).to eq 'ログインしました！'
          expect(cookies[:remember]).to eq true
        end
        it 'login without remembering' do
          expect_any_instance_of(ApplicationController).to receive(:log_in)
        
          params = {
            session: {
              email: user.email,
              password: user.password,
              remember_me: false,
            }
          }
  
          post '/login', params: params, headers: xhr_header
  
          expect(response).to have_http_status(200)
          json = JSON.parse(response.body)
          # expect(response.body).to be_falsey
          expect(json['message']).to eq 'ログインしました！'
        end
      end
    end

    context 'with invalid params' do
      it 'can not login with valid email and invalid password' do
        expect_any_instance_of(ApplicationController).to_not receive(:log_in)

        params = {
          session: {
            email: user.email,
            password: 'invalid_password'
          }
        }

        post '/login', params: params, headers: xhr_header

        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json['message']).to eq 'メールアドレスまたはパスワードが正しくありません。'
      end

      it 'can not login with invalid email and password' do
        expect_any_instance_of(ApplicationController).to_not receive(:log_in)

        params = {
          session: {
            email: 'invalid_user_email',
            password: 'invalid_password'
          }
        }

        post '/login', params: params, headers: xhr_header

        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json['message']).to eq 'メールアドレスまたはパスワードが正しくありません。'
      end
    end
  end

  describe 'DELETE /login' do
    it 'logout an user' do
      expect_any_instance_of(ApplicationController).to receive(:log_out)
      
      delete '/login', headers: xhr_header
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['message']).to eq 'ログアウトしました'
      expect(response.body).to be_falsey
    end
  end
end
