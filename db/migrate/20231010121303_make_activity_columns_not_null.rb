class MakeActivityColumnsNotNull < ActiveRecord::Migration[7.0]
  def change
    change_column_null(:activity_items, :activity_type, false, "Rating")
    change_column_null(:activity_items, :activity_id, false, 1)
    change_column_null(:activity_items, :description, false, "Lorem ipsum dolor sit amet")
    change_column_null(:activity_items, :user_id, false, 1)
  end
end
