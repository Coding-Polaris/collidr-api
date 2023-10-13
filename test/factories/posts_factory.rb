FactoryBot.define do
  factory :post do
    user { create(:user) }
    title { Faker::Lorem.sentence }    
    body { Faker::Lorem.paragraph }    

    trait :invalid do
      body { nil }
    end
  end
end
