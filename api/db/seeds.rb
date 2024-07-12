require 'faker'
Faker::Config.locale = :'pt-BR'
require 'cpf_cnpj'

user = User.create(name: 'User', email: 'user@email.com', password: '123456')

40.times do |i|
  user.contacts.create(
    name: Faker::Name.name,
    registration_number: CPF.generate,
    phone: Faker::PhoneNumber.phone_number,
    address: Faker::Address.city + ", " + Faker::Address.street_name + "-" + Faker::Address.state_abbr,
    zip_code: Faker::Address.zip_code,
    latitude: Faker::Address.latitude,
    longitude: Faker::Address.longitude,
  )
end