class AddLastHighRatingBroadcastTimeToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :last_high_rating_broadcast_time, :datetime
  end
end
