FactoryBot.define do
  factory :task do
    name { Faker::Name.name }
    description { Faker::Lorem.paragraphs }
    duration {5}
  end
end

