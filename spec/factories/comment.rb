FactoryBot.define do
  factory :comment do
    body { Faker::Lomen.characters(number: 20 ) }
  end
end