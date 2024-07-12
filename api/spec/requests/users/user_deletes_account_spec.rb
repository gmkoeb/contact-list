require 'rails_helper'

describe 'User deletes account' do
  it 'and all his data is deleted' do
    user = User.create(name: 'Test', email: 'test@email.com', password: '123456')
    user.contacts.create(name: 'Contact 1', registration_number: '30830071083', phone: '123456',
                         address: 'Test street, 155', zip_code: '123456', latitude: 123, longitude: 123)
    user.contacts.create(name: 'Contact 2', registration_number: '71005272018', phone: '123456',
                         address: 'Test street, 155', zip_code: '123456', latitude: 123, longitude: 123)

    token = login(user)
    delete '/account', headers: { Authorization: token },
                       params: { user: { password: '123456' } }
    json_response = JSON.parse(response.body)

    expect(response.status).to eq 200
    expect(json_response['message']).to eq 'Account deleted with success'
    expect(User.last).to be_nil
    expect(Contact.all.count).to eq 0
  end

  it 'and cant delete without a valid password' do
    user = User.create(name: 'Test', email: 'test@email.com', password: '123456')

    token = login(user)
    delete '/account', headers: { Authorization: token },
                       params: { user: { password: '654321' } }

    json_response = JSON.parse(response.body)

    expect(response.status).to eq 422
    expect(json_response['message']).to eq 'Wrong password. Try again'
    expect(User.last).to eq user
  end

  it 'and cant delete without being logged in' do
    user = User.create(name: 'Test', email: 'test@email.com', password: '123456')

    delete '/account', params: { user: { password: '123456' } }

    json_response = JSON.parse(response.body)

    expect(response.status).to eq 401
    expect(json_response['message']).to eq "Couldn't find an active session."
    expect(User.last).to eq user
  end
end
