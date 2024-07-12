require 'swagger_helper'
describe 'Accounts API' do
  path '/account' do
    delete 'Deletes user account' do
      tags 'Account'
      consumes 'application/json'
      security [Bearer: {}]
      parameter name: :Authorization, in: :header, type: :string
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              password: { type: :string }
            },
            required: %w[password]
          }
        },
        required: %w[user]
      }

      response '200', 'user deleted' do
        let!(:existing_user) { User.create(name: 'Test', email: 'test@example.com', password: 'password') }
        let(:Authorization) { "Bearer #{login(existing_user)}" }
        let(:user) { { user: { password: 'password' } } }
        run_test!
      end
    end
  end
end