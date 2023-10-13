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
describe Post, type: :model do
  let(:post) { build(:post) }
  subject { post }

  include_examples "SaveBroadcaster", :post

  %i[ title body user_id ].each do |field|
    it { should validate_presence_of(field) }
  end

  it { should validate_uniqueness_of(:title).scoped_to(:user_id) }

  it { should belong_to(:user) }
  it { should have_many(:comments) }
  it { should have_many(:activity_items) }
end
