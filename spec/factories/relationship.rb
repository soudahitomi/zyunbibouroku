FactoryBot.define do
  factory :rerationship do
    follower_id { FactoryBot.create(:user).id }
    followed_id { FactoryBot.create(:user).id }
  end
end