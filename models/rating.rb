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
class Rating < ActiveRecord::Base
  include Wisper::Publisher

  %i[rater_id ratee_id value].each do |field|
    validates field, presence: true
  end

  validates :rater_id, uniqueness: { scope: :ratee_id }
  validates :value,
    numericality: {
      in: (1..5),
      message: "must be from 1 to 5"
    },
    allow_blank: true

  belongs_to :rater, foreign_key: :rater_id, class_name: "User"
  belongs_to :ratee, foreign_key: :ratee_id, class_name: "User"

  def self.get_average_rating_for(user)
    result = Rating
      .where(ratee_id: user.id)
      .average(:value)
      .try(:round, 2)
  end
end
