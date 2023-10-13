class AllowNullGitHubNameInUser < ActiveRecord::Migration[7.0]
  def change
    change_column_null :users, :github_name, true
  end
end
