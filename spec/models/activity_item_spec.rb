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
describe ActivityItem, type: :model do
  # shoulda boilerplate
  subject { act = ActivityItem.new() }

  %i[
    activity_type
    activity_id
    description
    user_id
  ].each do |field|
    it { should validate_presence_of(field) }
  end
end
