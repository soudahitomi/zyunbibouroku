FactoryBot.define do
  factory :list do
    content { Faker::Lorem.characters(number: 10) }
  end
end