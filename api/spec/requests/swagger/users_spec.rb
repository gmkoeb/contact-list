require 'swagger_helper'

describe 'Users API' do
  path '/login' do
    post 'Authenticates a user' do
      tags 'Users'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string },
              password: { type: :string }
            },
            required: %w[email password]
          }
        },
        required: ['user']
      }

      response '200', 'user authenticated' do
        let!(:existing_user) { User.create(name: 'Test', email: 'test@example.com', password: 'password') }
        let(:user) { { user: { email: 'test@example.com', password: 'password' } } }
        run_test!
      end

      response '401', 'invalid request' do
        let(:user) { { user: { email: 'test@example.com' } } }
        run_test!
      end
    end
  end

  path '/signup' do
    post 'Creates a user' do
      tags 'Users'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              name: { type: :string },
              email: { type: :string },
              password: { type: :string }
            },
            required: %w[name email password]
          }
        },
        required: ['user']
      }

      response '200', 'user created' do
        let(:user) do
          { user: { name: 'test', email: 'test@email.com,', password: '123456' } }
        end
        run_test!
      end

      response '422', 'invalid request' do
        let(:user) { { user: { email: 'test@example.com' } } }
        run_test!
      end
    end
  end

  path '/logout' do
    delete 'Signs out a user' do
      tags 'Users'
      consumes 'application/json'
      let!(:existing_user) { User.create(name: 'Test', email: 'test@example.com', password: 'password') }
      let(:Authorization) { "Bearer #{login(existing_user)}" }
      security [Bearer: {}]
      parameter name: :Authorization, in: :header, type: :string

      response '200', 'user signed out with success' do
        run_test!
      end
    end
  end
end