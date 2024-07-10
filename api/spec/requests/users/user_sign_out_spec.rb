require 'rails_helper'

describe 'User signs out' do
  context 'DELETE /logout' do
    it 'successfully' do
      user = User.create(name: 'Test', email: 'test@email.com', password: '123456')

      token = login(user)

      delete destroy_user_session_path, headers: { Authorization: token }
      json_response = JSON.parse(response.body)

      expect(response.status).to eq 200
      expect(json_response['message']).to eq 'Logged out successfully.'
    end
  end
end
