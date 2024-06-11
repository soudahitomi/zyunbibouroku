FactoryBot.define do
  factory :post do
    title { Faker::Lorem.characters(number: 5) }
  end
end