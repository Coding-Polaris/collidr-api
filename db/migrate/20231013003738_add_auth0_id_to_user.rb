class AddAuth0IdToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :auth0_id, :string
  end
end
