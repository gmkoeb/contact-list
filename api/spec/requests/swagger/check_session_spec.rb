require 'swagger_helper'

describe 'Check Session API' do
  path '/check_session' do
    get 'Checks user session' do
      tags 'Check Session'
      consumes 'application/json'
      security [Bearer: {}]
      parameter name: :Authorization, in: :header, type: :string

      response '200', 'valid session' do
        let!(:existing_user) { User.create(name: 'Test', email: 'test@example.com', password: 'password') }
        let(:Authorization) { "Bearer #{login(existing_user)}" }
        run_test!
      end

      response '401', 'invalid session' do
        let(:Authorization) { "Bearer 123" }
        run_test!
      end
    end
  end
end