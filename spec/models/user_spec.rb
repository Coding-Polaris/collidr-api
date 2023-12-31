# == Schema Information
#
# Table name: users
#
#  id                              :bigint           not null, primary key
#  description                     :text
#  email                           :string           not null
#  github_name                     :string
#  last_high_rating_broadcast_time :datetime
#  name                            :string(30)       not null
#  rating                          :decimal(3, 2)
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  auth0_id                        :string
#
# Indexes
#
#  index_users_on_email        (email)
#  index_users_on_github_name  (github_name)
#  index_users_on_name         (name)
#  index_users_on_rating       (rating)
#
describe User, type: :model do
  # shoulda boilerplate
  let(:user) { create(:user) }
  subject { user }

  include_examples "SaveBroadcaster", :user

  %i{ email github_name name auth0_id }.each do |field|
    it { should validate_uniqueness_of(field) }
  end

  it { should validate_presence_of(:auth0_id) }
  it { should validate_uniqueness_of(:auth0_id) }

  it { should allow_value("", nil).for(:name) }
  it { should allow_value("", nil).for(:github_name) }
  it { should allow_value("", nil).for(:email) }

  it do
    should validate_numericality_of(:rating)
      .is_greater_than_or_equal_to(1)
      .is_less_than_or_equal_to(5)
      .with_message("must be from 1 to 5")
  end

  it { should have_many(:incoming_ratings) }
  it { should have_many(:outgoing_ratings) }
  it { should have_many(:posts) }
  it { should have_many(:comments) }
  it { should have_many(:profile_comments) }
  it { should have_many(:activity_items) }

  it "broadcasts when rating above four stars, but not if recent" do
    ratee = user

    expect do
      create(:rating, rater: create(:user), ratee: ratee, value: 4)
    end.to broadcast(:user_above_four_stars, ratee)

    last_item = ActivityItem.last
    expect(last_item).to have_attributes(
      activity_type: "User",
      activity_id: user.id,
      user_id: user.id,
      description: "just broke a 4-star rating!"
    )

    expect do
      create(:rating, rater: create(:user), ratee: ratee, value: 5)
    end.to_not broadcast(:user_above_four_stars, ratee)

    recent_activity = ActivityItem.where("id > ?", last_item.id)
    expect(recent_activity.map(&:description)).to_not include "just broke a 4-star rating!"
  end

  describe "#email" do
    it "is not valid with an invalid email format" do
      user.email = "invalid_email"
      user.valid?
      expect(user.errors[:email]).to include("is invalid")
    end
  end

  describe "#rating" do 
    it "is valid if rating is empty" do
      user.rating = nil
      user.valid?
      expect(user.errors[:rating]).to be_empty
    end

    it "is equal to an average of the user's total Rating values" do
      create(:rating, ratee: user, value: 4)
      expect(user.rating).to eq(4.to_f.round(2))

      create(:rating, ratee: user, value: 3)
      expect(user.rating).to eq(3.5.to_f.round(2))

      create(:rating, ratee: user, value: 5)
      expect(user.rating).to eq(4.to_f.round(2))
    end
  end

  describe "#github_name" do
    it "should reject names with multiple hyphens" do
      user.github_name = "many--hyphens"
      user.valid?
      expect(user.errors[:github_name]).to include("is invalid")
    end

    it "should reject names with invalid characters" do
      user.github_name = "invalid characters!"
      user.valid?
      expect(user.errors[:github_name]).to include("is invalid")
    end

    it "should accept names with valid characters" do
      user.github_name = "valid-username"
      user.valid?
      expect(user.errors[:github_name]).to be_empty
    end
  end

  describe "#rate_user" do
    it "should assign a rating to another user" do
      second_user = create(:user)
      user.rate_user(second_user, 4)
      # some weird resetting going on here that requires re-lookup of the ratee
      second_user = User.find_by(id: second_user.id)
      expect(second_user.rating).to eq(4)
    end
  end

  describe "#build_activity_timeline" do
    it "should grab sorted user activity" do
      newbie = create(:user)

      rating_number = 3
      random_events = [
        create_list(:comment, 5, { user: newbie }),
        create_list(:post, 5, { user: newbie }),
        create_list(:comment, 5, { user: newbie }),
        create_list(:rating, rating_number, { rater: newbie })
      ].flatten.shuffle

      timeline = newbie.build_activity_timeline(Time.now)
      expect(timeline.last).to have_attributes(user_id: newbie.id, description: "signed up on Collidr!")
      # recorded events as of this writing: comment, post, rating
      expect(timeline.length).to eq(random_events.length - rating_number + 1)
    end
  end
end
