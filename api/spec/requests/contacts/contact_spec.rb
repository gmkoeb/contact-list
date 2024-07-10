require 'rails_helper'

describe 'Contact API' do
  context 'POST /contacts' do
    it 'creates contact with success' do
      user = User.create(name: 'Test', email: 'test@email.com', password: '123456')

      token = login(user)
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

    it 'contact is not created if the user isnt authenticated' do
      post contacts_path, params: { contact: { name: 'Test', registration_number: '45608835050',
                                               phone: '123456', address: 'Test Street, 155', zip_code: '123456',
                                               latitude: 123, longitude: 123 } }

      json_response = JSON.parse(response.body)

      expect(response.status).to eq 401
      expect(json_response['message']).to eq "Couldn't find an active session."
      expect(Contact.all.count).to eq 0
      expect(Contact.last).to be_nil
    end

    it 'contact is not created with wrong parameters' do
      user = User.create(name: 'Test', email: 'test@email.com', password: '123456')

      token = login(user)
      post contacts_path, headers: { Authorization: token },
                          params: { contact: { name: '', registration_number: '00008835050',
                                               phone: '123456', address: 'Test Street, 155', zip_code: '123456',
                                               latitude: 123, longitude: 123 } }

      json_response = JSON.parse(response.body)

      expect(response.status).to eq 422
      expect(json_response['message']).to include "Name can't be blank"
      expect(json_response['message']).to include 'Registration number not valid'
      expect(Contact.all.count).to eq 0
      expect(Contact.last).to be_nil
    end
  end

  context 'GET /contacts' do
    it 'returns contacts list for authenticated user' do
      user = User.create(name: 'Test', email: 'test@email.com', password: '123456')
      second_user = User.create(name: 'Test 2', email: 'test2@email.com', password: '123456')
      user.contacts.create(name: 'Contact 1', registration_number: '30830071083', phone: '123456',
                           address: 'Test street, 155', zip_code: '123456', latitude: 123, longitude: 123)
      user.contacts.create(name: 'Contact 2', registration_number: '71005272018', phone: '123456',
                           address: 'Test street, 155', zip_code: '123456', latitude: 123, longitude: 123)
      second_user.contacts.create(name: 'Contact 3', registration_number: '30830071083', phone: '123456',
                                  address: 'Test street, 155', zip_code: '123456', latitude: 123, longitude: 123)

      token = login(user)
      get contacts_path, headers: { Authorization: token }

      contacts = JSON.parse(response.body)['contacts']

      expect(contacts.class).to eq Array
      expect(contacts.length).to eq 2
      expect(contacts[0]['name']).to eq 'Contact 1'
      expect(contacts[0]['registration_number']).to eq '30830071083'
      expect(contacts[0]['phone']).to eq '123456'
      expect(contacts[0]['address']).to eq 'Test street, 155'
      expect(contacts[0]['zip_code']).to eq '123456'
      expect(contacts[0]['latitude']).to eq 123
      expect(contacts[0]['longitude']).to eq 123
      expect(contacts[1]['name']).to eq 'Contact 2'
      expect(contacts).not_to include second_user.contacts
    end

    it 'user must be authenticated to retrieve a contacts list' do
      get contacts_path

      json_response = JSON.parse(response.body)

      expect(response.status).to eq 401
      expect(json_response['message']).to eq "Couldn't find an active session."
    end
  end
end
