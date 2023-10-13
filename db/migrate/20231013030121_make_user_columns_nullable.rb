require 'faker'
class MakeUserColumnsNullable < ActiveRecord::Migration[7.0]
  def change
    change_column_null :users, :email, true
    change_column_null :users, :name, true
    change_column_null :users, :auth0_id, false, "fake|#{Faker::Alphanumeric.alphanumeric(number:32)}"
  end
end
