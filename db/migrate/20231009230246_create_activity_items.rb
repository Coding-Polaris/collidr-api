class CreateActivityItems < ActiveRecord::Migration[7.0]
  def change
    create_table :activity_items do |t|
      t.integer :user_id
      t.integer :activity_id
      t.string :activity_type
      t.datetime :activity_time
      t.text :description

      t.timestamps
    end

    add_index :activity_items, :user_id
    add_index :activity_items, :activity_id
  end
end
