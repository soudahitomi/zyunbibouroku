FactoryBot.define do
  factory :list do
    content { Facer::Lorem.characters(number: 10) }
  end
end