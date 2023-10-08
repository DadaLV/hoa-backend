require 'rails_helper'

RSpec.describe 'Invitations API', type: :request do
  describe 'POST /api/v1/auth/invitation' do
    let(:inviter) { create(:user) }
    before do
      post '/api/v1/auth/sign_in', params: { email: inviter.email, password: inviter.password }
      @auth_headers = inviter.create_new_auth_token
    end

    context 'when creating an invitation' do
      it 'sends an invitation email' do
        post '/api/v1/auth/invitation', params: { user: { email: 'test8@test.com' } }, headers: @auth_headers

        expect(response).to have_http_status(201)
        expect(ActionMailer::Base.deliveries.size).to eq(1)

        invitation_email = ActionMailer::Base.deliveries.last
        expect(invitation_email.to).to include('test8@test.com')
        expect(invitation_email.subject).to include('Welcome to HOA platform')
      end
    end

    context 'when creating an invitation with invalid parameters' do
      it 'returns unprocessable entity status' do
        post '/api/v1/auth/invitation', params: { user: { invalid_param: 'invalid' } }, headers: @auth_headers

        expect(response).to have_http_status(422)
      end
    end

    context 'when unauthorized user tries to create an invitation' do
      it 'returns unauthorized status' do
        post '/api/v1/auth/invitation', params: { user: { email: 'test8@test.com' } }

        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'GET /api/v1/auth/invitation/accept' do
    let(:user) { create(:user) }

    context 'with valid invitation token' do
      it 'returns success' do
        user.invite!
        invitation_token = user.raw_invitation_token

        get "/api/v1/auth/invitation/accept", params: { invitation_token: invitation_token }

        expect(response).to have_http_status(200)
        expect(response.body).to include('Invitation link is valid.')
      end
    end
  end

  describe 'PATCH /api/v1/auth/invitation' do
    let(:user) { create(:user) }

    context 'with valid parameters' do
      it 'updates user and returns success' do
        user.invite!
        invitation_token = user.raw_invitation_token
        patch "/api/v1/auth/invitation", params: {
          password: 'New_password1!',
          password_confirmation: 'New_password1!',
          invitation_token: invitation_token
        }

        expect(response).to have_http_status(202)
        expect(response.body).to include('Your password has been successfully created!')
      end
    end
  end
end