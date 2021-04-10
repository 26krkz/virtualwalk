require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:xhr_header) {
    { 'X-Requested-With': 'XMLHttpRequest' }
  }
  let(:user) { FactoryBot.create(:user) }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  # describe "GET /users/:id" do
  #   it 'get user info' do

  #     get "users/#{user.id}", headers: xhr_header

  #     expect(response).to have_http_status(200)
  #     json = JSON.parse(response.body)
  #     expect(json['user']).to be_truthy
  #   end
  # end

  describe "POST /users" do
    context 'with valid params' do
      it 'creates new user' do
        expect_any_instance_of(ApplicationController).to receive(:log_in)
        expect_any_instance_of(ApplicationController).to receive(:logged_in?)

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
        }.to change(User, :count).by(1)

        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json['message']).to eq '登録が完了しました！'
      end
    end

    context 'with invalid params' do
      it 'does not create new user' do
        #これが必要かわかんない
        expect_any_instance_of(ApplicationController).to_not receive(:log_in)

        params = {
          user: {
            name: ' ',
            email: 'invalidemail',
            password: 'short',
            password_confirmation: 'short'
          }
        }

        expect {
          post "/users", params: params, headers: xhr_header
        }.to change(User, :count).by(0)

        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json['error']).to be_truthy
      end
    end
  end
end
