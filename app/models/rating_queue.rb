class RatingQueue
  def self.updated_rating(rating)
    self.get_and_update_ratee(rating)
  end 

  def self.created_rating(rating)
    self.get_and_update_ratee(rating)
  end 

  def self.user_is_rating(rater, ratee, value)
    rating = Rating.find_or_initialize_by(
      rater_id: rater.id,
      ratee_id: ratee.id,
    )
    rating.value = value
    rating.save
  end

  def self.get_and_update_ratee(rating)
    ratee = rating.ratee
    ratee.update_rating
    ratee.save
  end
end