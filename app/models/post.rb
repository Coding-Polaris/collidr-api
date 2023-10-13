# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  body       :text
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#
class Post < ApplicationRecord
  %i[
    body
    title
    user_id
  ].each do |field|
      validates field,
        presence: true
    end

  validates :title, uniqueness: { scope: :user_id }

  belongs_to :user
  has_many :comments, as: :reply
end
