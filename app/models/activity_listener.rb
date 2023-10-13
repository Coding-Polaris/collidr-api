# this is the listener that creates timeline items

class ActivityListener
  def self.user_above_four_stars(user)
    ActivityItem.create(
      activity_type: "User",
      activity_id: user.id,
      user_id: user.id,
      description: "just broke a 4-star rating!"
    )
  end

  def self.created_user(user)
    ActivityItem.create(
      activity_type: "User",
      activity_id: user.id,
      user_id: user.id,
      description: "signed up on Collidr!"
    )
  end

  def self.created_post(post)
    ActivityItem.create(
      activity_type: "Post",
      activity_id: post.id,
      user_id: post.user.id,
      description: "posted: #{post.title}"
    )
  end

  def self.created_comment(comment)
    description = ""
    description = case comment.reply.class.to_s
    when "User"
      profile_user = comment.reply
      "commented on #{profile_user}'s profile: #{comment.body}"
    when "Post"
      post = comment.reply
      "commented on #{post} by #{post.user}"
    else
      return
    end

    ActivityItem.create(
      activity_type: "Comment",
      activity_id: comment.id,
      user_id: comment.user.id,
      description: description
    )
  end
end