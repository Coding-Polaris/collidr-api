class MakeFieldsOnUserNonNullable < ActiveRecord::Migration[7.0]
  def change
    change_column_null(:users, :email, false, "npc@npc.email")
    change_column_null(:users, :github_name, false, "GenericGithub")
    change_column_null(:users, :name, false, "GenericGitguy")
  end
end
