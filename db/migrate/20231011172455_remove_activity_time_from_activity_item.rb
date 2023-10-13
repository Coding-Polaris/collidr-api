class RemoveActivityTimeFromActivityItem < ActiveRecord::Migration[7.0]
  def change
    remove_column :activity_items, :activity_time
  end
end
