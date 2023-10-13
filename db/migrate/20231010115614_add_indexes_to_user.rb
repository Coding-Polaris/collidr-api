class AddIndexesToUser < ActiveRecord::Migration[7.0]
  def change
    add_index :users, :email
    add_index :users, :github_name
    add_index :users, :name
    add_index :users, :rating
  end
end
