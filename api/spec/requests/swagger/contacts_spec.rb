require 'swagger_helper'

describe 'Contacts API' do
  path '/contacts' do
    let!(:existing_user) { User.create(name: 'Test', email: 'test@example.com', password: 'password') }
    let(:Authorization) { "Bearer #{login(existing_user)}" }

    post 'Creates a contact' do
      tags 'Contacts'
      consumes 'application/json'
      security [Bearer: {}]
      parameter name: :Authorization, in: :header, type: :string
      parameter name: :contact, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          registration_number: { type: :string },
          phone: { type: :string },
          address: { type: :string },
          zip_code: { type: :string },
          latitude: { type: :integer },
          longitude: { type: :integer }
        },
        required: %w[name registration_number address zip_code phone latitude longitude]
      }

      response '201', 'contact created' do
        let(:contact) do
          { name: 'test', registration_number: '32890565033', address: 'bla', zip_code: 'bla', phone: '123', latitude: 0, longitude: 0 }
        end
        run_test!
      end

      response '422', 'invalid request' do
        let(:contact) { { registration_number: 'test' } }
        run_test!
      end
    end

    get 'Retrieves contact list' do
      tags 'Contacts'
      produces 'application/json', 'application/xml'
      security [Bearer: {}]
      parameter name: :Authorization, in: :header, type: :string

      response '200', 'retrieves contacts list' do
        run_test!
      end
    end
  end

  path '/contacts/{id}' do
    get 'Retrieves a contact' do
      tags 'Contacts'
      produces 'application/json', 'application/xml'
      security [Bearer: {}]
      parameter name: :Authorization, in: :header, type: :string
      parameter name: :id, in: :path, type: :string
      request_body_example value: { some_field: 'Foo' }, name: 'basic', summary: 'Request example description'

      response '200', 'contact found' do
        let!(:existing_user) { User.create(name: 'Test', email: 'test@example.com', password: 'password') }
        let!(:existing_contact) { existing_user.contacts.create(name: 'Contact 1', registration_number: '30830071083', phone: '123456',
                                                                address: 'Test street, 155', zip_code: '123456', latitude: 123, longitude: 123) }
        let(:Authorization) { "Bearer #{login(existing_user)}" }
        let(:id) { existing_contact.id }
        run_test!
      end

      response '404', 'contact not found' do
        let!(:existing_user) { User.create(name: 'Test', email: 'test@example.com', password: 'password') }
        let(:Authorization) { "Bearer #{login(existing_user)}" }
        let(:id) { 'invalid' }
        run_test!
      end
    end

    patch 'Updates a contact' do
      tags 'Contacts'
      consumes 'application/json'
      security [Bearer: {}]
      parameter name: :Authorization, in: :header, type: :string
      parameter name: :id, in: :path, type: :string
      parameter name: :contact, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          registration_number: { type: :string },
          phone: { type: :string },
          address: { type: :string },
          zip_code: { type: :string },
          latitude: { type: :integer },
          longitude: { type: :integer }
        },
        required: %w[name registration_number address zip_code phone latitude longitude]
      }

      response '200', 'contact updated with success' do
        let!(:existing_user) { User.create(name: 'Test', email: 'test@example.com', password: 'password') }
        let!(:existing_contact) { existing_user.contacts.create(name: 'Contact 1', registration_number: '30830071083', phone: '123456',
                                                                address: 'Test street, 155', zip_code: '123456', latitude: 123, longitude: 123) }
        let(:Authorization) { "Bearer #{login(existing_user)}" }
        let(:id) { existing_contact.id }
        let(:contact) do
          { name: 'test', registration_number: '32890565033', address: 'bla', zip_code: 'bla', phone: '123', latitude: 0, longitude: 0 }
        end
        run_test!
      end

      response '422', 'invalid parameters' do
        let!(:existing_user) { User.create(name: 'Test', email: 'test@example.com', password: 'password') }
        let!(:existing_contact) { existing_user.contacts.create(name: 'Contact 1', registration_number: '30830071083', phone: '123456',
                                                                address: 'Test street, 155', zip_code: '123456', latitude: 123, longitude: 123) }
        let(:id) { existing_contact.id }
        let(:Authorization) { "Bearer #{login(existing_user)}" }
        let(:contact) { { registration_number: 'test' } }
        run_test!
      end
    end

    delete 'Deletes a contact' do
      tags 'Contacts'
      consumes 'application/json'
      security [Bearer: {}]
      parameter name: :Authorization, in: :header, type: :string
      parameter name: :id, in: :path, type: :string

      response '200', 'contact deleted with success' do
        let!(:existing_user) { User.create(name: 'Test', email: 'test@example.com', password: 'password') }
        let!(:existing_contact) { existing_user.contacts.create(name: 'Contact 1', registration_number: '30830071083', phone: '123456',
                                                                address: 'Test street, 155', zip_code: '123456', latitude: 123, longitude: 123) }
        let(:Authorization) { "Bearer #{login(existing_user)}" }
        let(:id) { existing_contact.id }
        run_test!
      end

      response '404', 'contact not found' do
        let!(:existing_user) { User.create(name: 'Test', email: 'test@example.com', password: 'password') }
        let!(:existing_contact) { existing_user.contacts.create(name: 'Contact 1', registration_number: '30830071083', phone: '123456',
                                                                address: 'Test street, 155', zip_code: '123456', latitude: 123, longitude: 123) }
        let(:id) { 'invalid' }
        let(:Authorization) { "Bearer #{login(existing_user)}" }
        run_test!
      end
    end
  end

  path '/address_helper/{uf}/{city}/{address}' do
    before do
      fake_json = File.read(Rails.root.join('./spec/support/json/addresses.json'))
      url = 'https://viacep.com.br/ws/PR/Curitiba/Fern/json/'
      fake_response = double('faraday_response', body: fake_json, status: 200)
      allow(Faraday).to receive(:get).with(url).and_return(fake_response)
    end
    get 'Retrieves address information' do
      tags 'Address Helper'
      produces 'application/json'
      security [Bearer: {}]
      parameter name: :Authorization, in: :header, type: :string
      parameter name: :Authorization, in: :header, type: :string
      parameter name: :uf, in: :path, type: :string
      parameter name: :city, in: :path, type: :string
      parameter name: :address, in: :path, type: :string

      response '200', 'address found' do
        schema type: :object,
        properties: {
          suggestions: {
            type: :array,
            items: {
              type: :object,
              properties: {
                cep: { type: :string },
                logradouro: { type: :string },
                complemento: { type: :string },
                bairro: { type: :string },
                localidade: { type: :string },
                uf: { type: :string },
                ibge: { type: :string },
                gia: { type: :string },
                ddd: { type: :string },
                siafi: { type: :string }
              },
              required: ['cep', 'logradouro', 'bairro', 'localidade', 'uf']
            }
          }
        },
        required: ['suggestions']
        let!(:existing_user) { User.create(name: 'Test', email: 'test@example.com', password: 'password') }
        let(:Authorization) { "Bearer #{login(existing_user)}" }
        let(:uf) { 'PR' }
        let(:city) { 'Curitiba' }
        let(:address) { 'Fern' }
        run_test!
      end
    end
  end
end
