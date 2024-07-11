require 'swagger_helper'

describe 'Contacts API' do

  path '/contacts' do
    let(:access_token) { }
    let(:Authorization) { "Bearer #{access_token}" }    

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
        required: [ 'name', 'registration_number', 'address', 'zip_code', 'latitude', 'longitude' ]
      }

      response '201', 'blog created' do
        let(:contact) { { name: 'foo', registration_number: 'bar', address: 'bla', zip_code: 'bla', latitude: 0, longitude: 0 } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:blog) { { title: 'foo' } }
        run_test!
      end
    end
  end

  path '/blogs/{id}' do

    get 'Retrieves a blog' do
      tags 'Blogs', 'Another Tag'
      produces 'application/json', 'application/xml'
      parameter name: :id, in: :path, type: :string
      request_body_example value: { some_field: 'Foo' }, name: 'basic', summary: 'Request example description'

      response '200', 'blog found' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            title: { type: :string },
            content: { type: :string }
          },
          required: [ 'id', 'title', 'content' ]

        let(:id) { Blog.create(title: 'foo', content: 'bar').id }
        run_test!
      end

      response '404', 'blog not found' do
        let(:id) { 'invalid' }
        run_test!
      end

      response '406', 'unsupported accept header' do
        let(:'Accept') { 'application/foo' }
        run_test!
      end
    end
  end
end