# == Schema Information
#
# Table name: users
#
#  id          :bigint           not null, primary key
#  description :text
#  email       :string
#  github_name :string
#  name        :string(30)
#  rating      :decimal(3, 2)    default(0.0)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_users_on_email        (email)
#  index_users_on_github_name  (github_name)
#  index_users_on_name         (name)
#  index_users_on_rating       (rating)
#
FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    name { Faker::Name.name }
    rating { nil }
    auth0_id { "fake|#{Faker::Alphanumeric.alphanumeric(number:32)}" }

    trait :has_github do
      sequence(:github_name) { |n| "#{Faker::Internet.unique.username(specifier: 8..39, separators: %w[-])}#{n}" }
    end

    trait :rated do
      rating { Faker::Number.between(from: 1, to: 5).to_f }
    end

    trait :invalid do
      rating { 42 }
    end
  end
end