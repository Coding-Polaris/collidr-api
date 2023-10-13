class DefaultUsersRatingToNull < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :rating, nil
  end
end
