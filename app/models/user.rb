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
class User < ApplicationRecord
  RECENT_RATING_WINDOW = 1.month
  HIGH_RATING = 4.00

  %i[
    email
    name
  ].each do |field|
      validates field,
        uniqueness: true,
        allow_blank: true
    end

  validates :auth0_id,
    uniqueness: true,
    presence: true

  validates :github_name,
    uniqueness: true,
    allow_blank: true

  validates :rating,
    numericality: {
      in: (1..5),
      message: "must be from 1 to 5"
    },
    allow_blank: true

  {
    email: /\A\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w+)$\z/,
    github_name: /\A[a-z\d](?:[a-z\d]|-(?=[a-z\d])){0,38}\z/i
  }.each do |field, regex|
      validates_format_of field, with: regex, allow_blank: :github_name
    end

  after_create :add_github_history_import_to_job_queue, if: :github_name_present?

  after_save :broadcast_rating_at_or_above_four_and_set_last_high_rating_broadcast_time,
    if: :should_broadcast_high_rating

  has_many :incoming_ratings, as: :ratee, class_name: "Rating"
  has_many :outgoing_ratings, as: :rater, class_name: "Rating"
  has_many :posts
  has_many :comments
  has_many :profile_comments, as: :reply, class_name: "Comment"
  has_many :activity_items

  def github_name=(value)
    value = nil if value == ""
    super(value)
  end

  def rate_user(user, value)
    broadcast(:user_is_rating, self, user, value)
  end

  def to_s
    if self.name.present?
      return self.name
    elsif self.github_name.present?
      return self.github_name
    end
    "User\##{user.id}"
  end

  # retrieve starting from a certain time point
  def build_activity_timeline(time_from = DateTime.now, time_to = nil, limit = 20)
    items = []

    collidr_activity = ActivityItem.where("
        user_id = ? AND
        updated_at < ?
      ", self.id, time_from)
      .order("updated_at DESC")
      .limit(limit)
    items += collidr_activity

    # if self.github_name.present?
    #   github_activity = self.get_github_events(github_name, time_from, time_to, limit)
    #   items += github_activity
    #   sort_timeline(timeline)
    # end

    items[0..limit - 1]
  end

  def get_github_events(time_from = DateTime.now, time_to = nil, limit = 20)
    poller = GitHubPoller.new
    poller.get_events(github_name, time_from, time_to, limit)
  end

  def update_rating
    self.rating = Rating.get_average_rating_for(self)
  end

  private

  def github_name_present?
    self.github_name.present?
  end

  def add_github_history_import_to_job_queue
    importer = ImportGithubHistory.new
    importer.perform(self)
  end

  def broadcast_rating_at_or_above_four_and_set_last_high_rating_broadcast_time
    broadcast(:user_above_four_stars, self)
    if rating_at_or_above_four_stars && !last_high_rating_broadcast_is_recent?
      self.last_high_rating_broadcast_time = DateTime.now
    end
  end

  def rating_at_or_above_four_stars
    self.rating >= HIGH_RATING
  end

  def last_high_rating_broadcast_is_recent?
    # !! changes nil to false
    conditional = !!(self.last_high_rating_broadcast_time && self.last_high_rating_broadcast_time > RECENT_RATING_WINDOW.ago)
  end

  def should_broadcast_high_rating
    !last_high_rating_broadcast_is_recent? &&
      saved_change_to_rating? &&
      rating_at_or_above_four_stars
  end
end
