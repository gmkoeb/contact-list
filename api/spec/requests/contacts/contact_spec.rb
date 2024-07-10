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
end
