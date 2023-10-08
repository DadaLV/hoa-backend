require 'rails_helper'

RSpec.describe 'Password Reset API', type: :request do
  let(:user) { create(:user) }

  before do
    post '/api/v1/auth/sign_in', params: { email: user.email, password: user.password }
    @auth_headers = user.create_new_auth_token
  end

  describe 'POST /api/v1/auth/password' do
    context 'when requesting password reset for a valid user' do
      it 'sends a password reset email' do

        post '/api/v1/auth/password', params: { email: user.email, redirect_url: ENV['ROOT_FRONTEND_URL'] + 'login/create-new-password' }

        expect(response).to have_http_status(200)

      end
    end

    context 'when requesting password reset for an invalid user' do
      it 'returns an error' do
        post '/api/v1/auth/password', params: { email: 'invalid@example.com', redirect_url: ENV['ROOT_FRONTEND_URL'] + 'login/create-new-password' }

        expect(response).to have_http_status(404)

      end
    end
    context "when using the same password as current password" do
      it "denies updating to the current password" do
        patch "/api/v1/auth/password", params: {
          password: user.password,
          password_confirmation: user.password,
          current_password: user.password
        }, headers: @auth_headers, as: :json
  
        expect(response).to have_http_status(422)
        body = JSON.parse(response.body)
        expect(body["errors"]).to include("can't be the same as your current password")
      end
    end
  end
end