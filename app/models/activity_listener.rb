class ActivityListener
  def self.user_above_four_stars(user)
  	ActivityItem.create(
  		activity_type: "User",
  		activity_id: user.id,
  		user_id: user.id,
  		description: "Just broke a 4-star rating!"
	)
  end
end