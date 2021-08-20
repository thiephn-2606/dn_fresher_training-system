FactoryBot.define do
  factory :user do
    email { Faker::Internet.email.upcase }
    name { Faker::Name.name }
    password {"thiephuynh"}
    password_confirmation {"thiephuynh"}
    address { Faker::Address.full_address }
  end
end
