class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.integer :user_id, null: false
      t.integer :reply_id, null: false
      t.string :reply_type, null: false
      t.text :body, null: false

      t.timestamps
    end

    add_index :comments, :user_id
    add_index :comments, :reply_id
  end
end
