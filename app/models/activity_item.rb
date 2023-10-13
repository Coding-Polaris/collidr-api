# == Schema Information
#
# Table name: activity_items
#
#  id            :bigint           not null, primary key
#  activity_type :string           not null
#  description   :text             not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  activity_id   :integer          not null
#  user_id       :integer          not null
#
# Indexes
#
#  index_activity_items_on_activity_id  (activity_id)
#  index_activity_items_on_user_id      (user_id)
#

# ActivityItem is a public log of various activities on the app.
# For example, Users joining collidr, engaging in various
# Git activities, or making Posts/Comments.
class ActivityItem < ApplicationRecord
  %i[
    activity_type
    activity_id
    description
    user_id
  ].each do |field|
    validates field, presence: true
  end
end
