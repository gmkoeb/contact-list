require 'rails_helper'

RSpec.describe Contact, type: :model do
  describe '#valid' do
    context 'presence' do
      it 'name cant be blank' do
        user = User.create(name: 'Test', email: '123@email.com', password: '123456')
        contact = user.contacts.build(name: '', registration_number: '30830071083', phone: '123456',
                                      address: 'Test street, 155', zip_code: '123456', latitude: 123, longitude: 123)

        expect(contact).not_to be_valid
        expect(contact.errors['name']).to include "can't be blank"
      end

      it 'registration number cant be blank' do
        user = User.create(name: 'Test', email: '123@email.com', password: '123456')
        contact = user.contacts.build(name: 'Test', registration_number: '', phone: '123456',
                                      address: 'Test street, 155', zip_code: '123456', latitude: 123, longitude: 123)

        expect(contact).not_to be_valid
        expect(contact.errors['registration_number']).to include "can't be blank"
      end

      it 'phone cant be blank' do
        user = User.create(name: 'Test', email: '123@email.com', password: '123456')
        contact = user.contacts.build(name: 'Test', registration_number: '30830071083', phone: '',
                                      address: 'Test street, 155', zip_code: '123456', latitude: 123, longitude: 123)

        expect(contact).not_to be_valid
        expect(contact.errors['phone']).to include "can't be blank"
      end

      it 'address cant be blank' do
        user = User.create(name: 'Test', email: '123@email.com', password: '123456')
        contact = user.contacts.build(name: 'Test', registration_number: '30830071083', phone: '123456',
                                      address: '', zip_code: '123456', latitude: 123, longitude: 123)

        expect(contact).not_to be_valid
        expect(contact.errors['address']).to include "can't be blank"
      end

      it 'zip code cant be blank' do
        user = User.create(name: 'Test', email: '123@email.com', password: '123456')
        contact = user.contacts.build(name: 'Test', registration_number: '30830071083', phone: '123456',
                                      address: 'Test street, 155', zip_code: '', latitude: 123, longitude: 123)

        expect(contact).not_to be_valid
        expect(contact.errors['zip_code']).to include "can't be blank"
      end

      it 'latitude cant be blank' do
        user = User.create(name: 'Test', email: '123@email.com', password: '123456')
        contact = user.contacts.build(name: 'Test', registration_number: '30830071083', phone: '123456',
                                      address: 'Test street, 155', zip_code: '', latitude: '', longitude: 123)

        expect(contact).not_to be_valid
        expect(contact.errors['latitude']).to include "can't be blank"
      end

      it 'longitude cant be blank' do
        user = User.create(name: 'Test', email: '123@email.com', password: '123456')
        contact = user.contacts.build(name: 'Test', registration_number: '30830071083', phone: '123456',
                                      address: 'Test street, 155', zip_code: '', latitude: 123, longitude: '')

        expect(contact).not_to be_valid
        expect(contact.errors['longitude']).to include "can't be blank"
      end
    end

    context 'registration number validation' do
      it 'valid' do
        user = User.create(name: 'Test', email: '123@email.com', password: '123456')
        contact = user.contacts.build(name: 'Test', registration_number: '30830071083', phone: '123456',
                                      address: 'Test street, 155', zip_code: '123456', latitude: 123, longitude: 123)

        expect(contact).to be_valid
      end

      it 'not valid' do
        user = User.create(name: 'Test', email: '123@email.com', password: '123456')
        contact = user.contacts.build(name: 'Test', registration_number: '00830071083', phone: '123456',
                                      address: 'Test street, 155', zip_code: '123456', latitude: 123, longitude: 123)

        expect(contact).not_to be_valid
        expect(contact.errors['registration_number']).to include 'not valid'
      end

      it 'must be unique for each user' do
        user = User.create(name: 'Test', email: '123@email.com', password: '123456')
        user.contacts.create(name: 'Test', registration_number: '30830071083', phone: '123456',
                             address: 'Test street, 155', zip_code: '123456', latitude: 123, longitude: 123)
        contact = user.contacts.create(name: 'Test', registration_number: '30830071083', phone: '123456',
                                       address: 'Test street, 155', zip_code: '123456', latitude: 123, longitude: 123)
        expect(contact).not_to be_valid
        expect(contact.errors['registration_number']).to include 'already exists for this user'
      end
    end
  end
end
