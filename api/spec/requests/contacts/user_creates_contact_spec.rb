require 'rails_helper'

describe 'User creates contact' do
  it 'with success' do
    user = User.create(name: 'Test', email: 'test@email.com', password: '123456')

    post user_session_path, params: { user: { email: 'test@email.com', password: '123456' } }
    json_response = JSON.parse(response.body)
    token = json_response['status']['data']['Authorization']['token']

    post contacts_path, headers: { Authorization: token },
                        params: { contact: { name: 'Test', registration_number: '45608835050',
                                             phone: '123456', address: 'Test Street, 155', zip_code: '123456',
                                             latitude: 123, longitude: 123 } }

    contact = Contact.last
    json_response = JSON.parse(response.body)

    expect(response.status).to eq 200
    expect(json_response['message']).to eq 'Contact created with success!'
    expect(contact.user).to eq user
    expect(contact.name).to eq 'Test'
    expect(contact.registration_number).to eq '45608835050'
    expect(contact.phone).to eq '123456'
    expect(contact.address).to eq 'Test Street, 155'
    expect(contact.zip_code).to eq '123456'
    expect(contact.latitude).to eq 123
    expect(contact.longitude).to eq 123
  end

  it 'and is not logged in' do
    post contacts_path, params: { contact: { name: 'Test', registration_number: '45608835050',
                                             phone: '123456', address: 'Test Street, 155', zip_code: '123456',
                                             latitude: 123, longitude: 123 } }
    json_response = JSON.parse(response.body)
    expect(response.status).to eq 401
    expect(json_response['message']).to eq "Couldn't find an active session." 
  end

  it 'with wrong parameters' do
    User.create(name: 'Test', email: 'test@email.com', password: '123456')

    post user_session_path, params: { user: { email: 'test@email.com', password: '123456' } }
    json_response = JSON.parse(response.body)
    token = json_response['status']['data']['Authorization']['token']

    post contacts_path, headers: { Authorization: token },
                        params: { contact: { name: '', registration_number: '00008835050',
                                             phone: '123456', address: 'Test Street, 155', zip_code: '123456',
                                             latitude: 123, longitude: 123 } }

    json_response = JSON.parse(response.body)
    
    expect(response.status).to eq 422
    expect(json_response['message']).to include "Name can't be blank"
    expect(json_response['message']).to include "Registration number not valid"
  end
end
