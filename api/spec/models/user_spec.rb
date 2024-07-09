require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#valid' do
    context 'presence' do
      it 'name cant be blank' do
        user = User.new(name: '', email: '123@email.com', password: '123456')

        expect(user).not_to be_valid
        expect(user.errors['name']).to include "can't be blank"
      end
    end

    context 'uniqueness' do
      it 'name must be unique' do
        User.create(name: 'Test', email: '123@email.com', password: '123456')
        user = User.new(name: 'Test', email: '456@email.com', password: '123456')

        expect(user).not_to be_valid
        expect(user.errors['name']).to include 'has already been taken'
      end
    end
  end
end
