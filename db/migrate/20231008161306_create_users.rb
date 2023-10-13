class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name, limit: 30, unique: true
      t.string :email, unique: true
      t.string :github_name
      t.text :description
      t.decimal :rating, precision: 3, scale: 2, default: 0.00

      t.timestamps
    end
  end
end
