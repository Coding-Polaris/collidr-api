FactoryBot.define do
  factory :comment do
    user { create(:user) }
    body { Faker::Lorem::paragraph }
    reply { create(:post) }
  end
end
