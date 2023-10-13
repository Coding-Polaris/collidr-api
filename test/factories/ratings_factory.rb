# == Schema Information
#
# Table name: ratings
#
#  id         :bigint           not null, primary key
#  value      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  ratee_id   :integer
#  rater_id   :integer
#
# Indexes
#
#  index_ratings_on_ratee_id               (ratee_id)
#  index_ratings_on_rater_id_and_ratee_id  (rater_id,ratee_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (ratee_id => users.id)
#  fk_rails_...  (rater_id => users.id)
#
FactoryBot.define do
  factory :rating do
    value { Faker::Number.between(from: 1, to: 5) }
    rater { association :user }
    ratee { association :user }
  end
end