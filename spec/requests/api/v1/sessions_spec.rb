require 'rails_helper'

RSpec.describe 'SessionsController', type: :request do
  let(:user) { create :user }
  describe 'POST api/v1/auth/sign_in' do

    it 'signs in a user successfully' do
      post '/api/v1/auth/sign_in', params: user.slice(:email, :password)
      expect(response).to have_http_status(200)
      expect(response.headers['access-token']).to be_present
      expect(response.headers['client']).to be_present
      expect(response.headers['uid']).to eq(user.email)
      expect(response.headers['expiry']).to be_present
    end

    it 'returns unauthorized for incorrect password' do
      post '/api/v1/auth/sign_in', params: { email: 'test4@test.com', password: 'Password4!!!' }
      expect(response).to have_http_status(401)
    end

    it 'returns a valid authentication token when "Remember Me" option is checked' do
      post '/api/v1/auth/sign_in', params: { email: user.email, password: user.password, remember_me: '1' }
      expect(user.reload.remember_expires_at > Time.zone.now).to be_truthy       
    end

    it 'returns a 401 unauthorized status when "Remember Me" option is not checked' do
      post '/api/v1/auth/sign_in', params: { email: user.email, password: user.password, remember_me: false }      
      expect(response).to have_http_status(200)
      expect(response.headers['access-token']).not_to be_nil

      get '/api/v1/auth/validate_token', params: { email: user.email, password: user.password }  
      expect(response).to have_http_status(401)  
    end
  end

  describe 'DELETE api/v1/auth/sign_out' do

    it 'signs out a user successfully' do
      post '/api/v1/auth/sign_in', params: user.slice(:email, :password)
      expect(response).to have_http_status(200)

      access_token = response.headers['access-token']
      client = response.headers['client']
      uid = response.headers['uid']

      delete '/api/v1/auth/sign_out', headers: {
        'access-token': access_token,
        'client': client,
        'uid': uid
      }
      expect(response).to have_http_status(200)

      get '/api/v1/auth/validate_token', headers: {
        'access-token': access_token,
        'client': client,
        'uid': uid
      }

      expect(response).to have_http_status(401)
    end

    it 'clears the user\'s remember token when signing out' do
      
      post '/api/v1/auth/sign_in', params: { email: user.email, password: user.password, remember_me: '1' }
      expect(response).to have_http_status(200) 
      expect(user.reload.remember_expires_at > Time.zone.now).to be_truthy
      expect(user.reload.remember_expires_at).not_to be_nil
      
      
      access_token = response.headers['access-token']
      client = response.headers['client']
      uid = response.headers['uid']
      
      get '/api/v1/auth/validate_token', headers: {
        'access-token': access_token,
        'client': client,
        'uid': uid
      }
      expect(response).to have_http_status(200)

      delete '/api/v1/auth/sign_out', headers: {
        'access-token': access_token,
        'client': client,
        'uid': uid
      }
    
      expect(response).to have_http_status(200)
      
      expect(user.reload.remember_created_at).to be_nil
      get '/api/v1/auth/validate_token', headers: {
        'access-token': access_token,
        'client': client,
        'uid': uid
      }
      expect(response).to have_http_status(401)
    end
  end

end