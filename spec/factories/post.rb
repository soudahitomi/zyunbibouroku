FactoryBot.define do
  factory :post do
    title { Facer::Lorem.characters(number: 5) }
  end
end