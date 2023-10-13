# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  body       :text             not null
#  reply_type :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  reply_id   :integer          not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_comments_on_reply_id  (reply_id)
#  index_comments_on_user_id   (user_id)
#
class Comment < ApplicationRecord
  %i[
    user_id
    reply_type
    reply_id
    body
  ].each do |field|
    validates field, presence: true
  end

  belongs_to :user
  belongs_to :reply, polymorphic: true
  has_many :sub_comments, as: :reply, class_name: "Comment"
end
