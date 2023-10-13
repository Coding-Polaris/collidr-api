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
describe Rating, type: :model do
  let(:rating) { create(:rating) }
  subject { rating }

  %i{ rater_id ratee_id value }.each do |field|
    it { should validate_presence_of(field) }
  end

  it { should validate_uniqueness_of(:rater_id).scoped_to(:ratee_id) }

  it do
    should validate_numericality_of(:value)
      .is_greater_than_or_equal_to(1)
      .is_less_than_or_equal_to(5)
      .with_message("must be from 1 to 5")
  end

  it { should belong_to(:rater) }
  it { should belong_to(:ratee) }

  describe ".get_average_rating_for" do
    before do
      Rating.destroy_all
      User.destroy_all
      @queried_average = nil
    end

    let(:ratee) { create(:user) }
    let(:ratings) do
      list = build_list(:rating, rand(0...100)) do |r|
        r.rater = create(:user)
        r.ratee = ratee
        r.save!
      end
    end
    let(:length) { ratings.length }
    let(:average) { (ratings.map(&:value).sum / length.to_f).round(2) }

    it "returns the average rating for a user" do
      ratings.each(&:save)
      expect(Rating.get_average_rating_for(ratee)).to eq(average)
    end
  end
end
