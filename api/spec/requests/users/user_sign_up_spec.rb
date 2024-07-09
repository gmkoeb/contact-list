require 'rails_helper'

describe 'User signs up' do
  context 'POST /signup' do
    it 'successfully' do
      post user_registration_path, params: { user: { name: 'Test', email: 'test@email.com', password: '123456' } }

      json_response = JSON.parse(response.body)
      user = User.last

      expect(response.status).to eq 200
      expect(json_response['status']['message']).to eq 'Signed up successfully.'
      expect(json_response['data']['id']).to eq 1
      expect(json_response['data']['email']).to eq 'test@email.com'
      expect(json_response['data']['name']).to eq 'Test'
      expect(user.name).to eq 'Test'
      expect(user.email).to eq 'test@email.com'
    end

    it 'with blank parameters' do
      post user_registration_path, params: { user: { name: '', email: '', password: '' } }

      json_response = JSON.parse(response.body)

      expect(response.status).to eq 422
      expect(json_response['status']['message']).to eq "User couldn't be created successfully. Email can't be blank, " \
                                                      "Password can't be blank, and Name can't be blank"
      expect(User.last).to be_nil
    end

    it 'with invalid password' do
      post user_registration_path, params: { user: { name: 'Test', email: 'test2@email.com', password: '12345' } }

      json_response = JSON.parse(response.body)

      expect(response.status).to eq 422
      expect(json_response['status']['message']).to eq "User couldn't be created successfully. " \
                                                      'Password is too short (minimum is 6 characters)'
      expect(User.last).to be_nil
    end

    it 'with non-unique email' do
      User.create(name: 'Test', email: 'test@email.com', password: '123456')
      user = User.last
      post user_registration_path, params: { user: { name: 'Test 2', email: 'test@email.com', password: '123456' } }

      json_response = JSON.parse(response.body)

      expect(response.status).to eq 422
      expect(json_response['status']['message']).to eq "User couldn't be created successfully. " \
                                                      'Email has already been taken'
      expect(User.last).to eq user
    end

    it 'with non-unique name' do
      User.create(name: 'Test', email: 'test@email.com', password: '123456')
      user = User.last
      post user_registration_path, params: { user: { name: 'Test', email: 'test2@email.com', password: '123456' } }

      json_response = JSON.parse(response.body)

      expect(response.status).to eq 422
      expect(json_response['status']['message']).to eq "User couldn't be created successfully. " \
                                                      'Name has already been taken'
      expect(User.last).to eq user
    end
  end
end
