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
require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:comment) { create(:comment) }
  subject { comment }

  %i{ body reply_type reply_id user_id }.each do |field|
    it { should validate_presence_of(field) }
  end

  it { should belong_to(:user) }
  it { should belong_to(:reply) }
  it { should have_many(:sub_comments) }
end
