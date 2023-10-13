class CreateRatings < ActiveRecord::Migration[7.0]
  def change
    create_table :ratings do |t|
      t.integer :rater_id
      t.integer :ratee_id
      t.integer :value

      t.timestamps
    end

    add_index :ratings, [:rater_id, :ratee_id], unique: true
    add_index :ratings, :ratee_id

    add_foreign_key :ratings, :users, column: :rater_id
    add_foreign_key :ratings, :users, column: :ratee_id
  end
end
