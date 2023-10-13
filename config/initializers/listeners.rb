Rails.application.reloader.to_prepare do
  Wisper.subscribe(ActivityListener, on: :created_comment)
  Wisper.subscribe(ActivityListener, on: :created_post)
  Wisper.subscribe(ActivityListener, on: :created_user)
  Wisper.subscribe(ActivityListener, on: :user_above_four_stars)
end