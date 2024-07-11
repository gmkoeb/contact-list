require 'rails_helper'

describe 'Address Helper' do
  context 'GET /address_helper/:UF/:city/:address' do
    it 'returns a list with address suggestions depending on parameters' do
      user = User.create(name: 'Test', email: 'test@email.com', password: '123456')
      token = login(user)
      fake_json = File.read(Rails.root.join('./spec/support/json/addresses.json'))
      url = 'https://viacep.com.br/ws/PR/curitiba/fern/json/'
      fake_response = double('faraday_response', body: fake_json, status: 200)
      allow(Faraday).to receive(:get).with(url).and_return(fake_response)

      get '/address_helper/PR/Curitiba/Fern', headers: { Authorization: token }
      json_response = JSON.parse(response.body)

      expect(response.status).to eq 200
      expect(json_response['suggestions'][0]['cep']).to eq '80050-432'
      expect(json_response['suggestions'][0]['logradouro']).to eq 'Rua Fernando Amaro'
      expect(json_response['suggestions'][0]['complemento']).to eq 'de 1441/1442 ao fim'
      expect(json_response['suggestions'][0]['bairro']).to eq 'Cristo Rei'
      expect(json_response['suggestions'][0]['localidade']).to eq 'Curitiba'
      expect(json_response['suggestions'][0]['uf']).to eq 'PR'
      expect(json_response['suggestions'][0]['ibge']).to eq '4106902'
      expect(json_response['suggestions'][0]['ddd']).to eq '41'
      expect(json_response['suggestions'][0]['siafi']).to eq '7535'
      expect(json_response['suggestions'][1]['cep']).to eq '82650-000'
      expect(json_response['suggestions'][1]['logradouro']).to eq 'Rua Fernando de Noronha'
      expect(json_response['suggestions'][1]['complemento']).to eq 'de 1941/1942 ao fim'
      expect(json_response['suggestions'][1]['bairro']).to eq 'Santa Cândida'
      expect(json_response['suggestions'][1]['localidade']).to eq 'Curitiba'
      expect(json_response['suggestions'][1]['uf']).to eq 'PR'
      expect(json_response['suggestions'][1]['ibge']).to eq '4106902'
      expect(json_response['suggestions'][1]['ddd']).to eq '41'
      expect(json_response['suggestions'][1]['siafi']).to eq '7535'
    end

    it 'user must be authenticated to get address suggestions' do
      get '/address_helper/PR/Curitiba/Fern'

      json_response = JSON.parse(response.body)
      expect(response.status).to eq 401
      expect(json_response['message']).to eq "Couldn't find an active session."
    end

    it 'api returns an empty body response if no suggestions are found' do
      user = User.create(name: 'Test', email: 'test@email.com', password: '123456')
      token = login(user)

      url = 'https://viacep.com.br/ws/RP/crt/test/json/'
      fake_response = double('faraday_response', body: '[]', status: 200)
      allow(Faraday).to receive(:get).with(url).and_return(fake_response)

      get '/address_helper/RP/crt/test', headers: { Authorization: token }
      json_response = JSON.parse(response.body)

      expect(response.status).to eq 200
      expect(json_response['suggestions']).to eq []
    end
  end
end
