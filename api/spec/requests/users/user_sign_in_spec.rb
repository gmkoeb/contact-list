require 'rails_helper'

describe 'User signs in' do
  context 'POST /login' do
    it 'success' do
      User.create(name: 'Test', email: 'test@email.com', password: '123456')

      post user_session_path, params: { user: { email: 'test@email.com', password: '123456' } }
      json_response = JSON.parse(response.body)

      expect(response.status).to eq 200
      expect(json_response['status']['message']).to eq 'Logged in successfully.'
      expect(json_response['status']['data']['user']['name']).to eq 'Test'
      expect(json_response['status']['data']['user']['email']).to eq 'test@email.com'
    end

    it 'with wrong parameters' do
      User.create(name: 'Test', email: 'test@email.com', password: '123456')

      post user_session_path, params: { user: { email: 'test@email.com', password: '43214' } }

      expect(response.status).to eq 401
      expect(response.body).to eq 'Invalid Email or password.'
    end
  end
end
