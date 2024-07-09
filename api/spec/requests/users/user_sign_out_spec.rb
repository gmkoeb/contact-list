require 'rails_helper'

describe 'User signs out' do
  context 'DELETE /logout' do
    it 'successfully' do
      User.create(name: 'Test', email: 'test@email.com', password: '123456')

      post user_session_path, params: { user: { email: 'test@email.com', password: '123456' } }
      json_response = JSON.parse(response.body)
      token = json_response['status']['data']['Authorization']['token']

      delete destroy_user_session_path, headers: { Authorization: token }
      json_response = JSON.parse(response.body)

      expect(response.status).to eq 200
      expect(json_response['message']).to eq 'Logged out successfully.'
    end
  end
end
