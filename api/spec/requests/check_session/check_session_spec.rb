describe 'Check Session' do
  context 'GET /check_session' do
    it 'returns success if headers are valid' do
      user = User.create(name: 'Test', email: 'test@email.com', password: '123456')
      token = login(user)

      get '/check_session', headers: { Authorization: token }

      expect(JSON.parse(response.body)['session']).to eq 'Authorized'
    end

    it 'returns unauthorized if the token is invalid' do
      get '/check_session', headers: { Authorization: '12345' }
      json_response = JSON.parse(response.body)

      expect(response.status).to eq 401
      expect(json_response['message']).to eq "Couldn't find an active session."
    end
  end
end
