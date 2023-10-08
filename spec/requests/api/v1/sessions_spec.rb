require 'rails_helper'

RSpec.describe 'SessionsController', type: :request do
  describe 'POST api/v1/auth/sign_in' do
    let(:user) { create :user }

    it 'signs in a user successfully' do
      post '/api/v1/auth/sign_in', params: user.slice(:email, :password)
      expect(response).to have_http_status(200)
      expect(response.headers['access-token']).to be_present
      expect(response.headers['client']).to be_present
      expect(response.headers['uid']).to eq(user.email)
      expect(response.headers['expiry']).to be_present
    end

    it 'returns unauthorized for incorrect password' do
      post '/api/v1/auth/sign_in', params: { email: 'test4@test.com', password: 'wrong_password' }
      expect(response).to have_http_status(401)
    end

    it 'returns a valid authentication token when "Remember Me" option is checked' do
      post '/api/v1/auth/sign_in', params: { email: user.email, password: user.password, remember_me: '1' }      
      expect(response).to have_http_status(200)
      expect(response.headers['access-token']).not_to be_nil

      auth_tokens = {
        'access-token': response.headers['access-token'],
        'client': response.headers['client'],
        'uid': response.headers['uid']
      }

      get '/api/v1/auth/validate_token', headers: auth_tokens  
      expect(response).to have_http_status(200)  
    end

    it 'returns a 401 unauthorized status when "Remember Me" option is not checked' do
      post '/api/v1/auth/sign_in', params: { email: user.email, password: user.password, remember_me: false }      
      expect(response).to have_http_status(200)
      expect(response.headers['access-token']).not_to be_nil

      get '/api/v1/auth/validate_token', params: { email: user.email, password: user.password }  
      expect(response).to have_http_status(401)  
    end
    
  end
end