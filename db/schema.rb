# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_10_13_030121) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activity_items", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "activity_id", null: false
    t.string "activity_type", null: false
    t.text "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_id"], name: "index_activity_items_on_activity_id"
    t.index ["user_id"], name: "index_activity_items_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "reply_id", null: false
    t.string "reply_type", null: false
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reply_id"], name: "index_comments_on_reply_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.integer "user_id"
    t.string "title"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "ratings", force: :cascade do |t|
    t.integer "rater_id"
    t.integer "ratee_id"
    t.integer "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ratee_id"], name: "index_ratings_on_ratee_id"
    t.index ["rater_id", "ratee_id"], name: "index_ratings_on_rater_id_and_ratee_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name", limit: 30
    t.string "email"
    t.string "github_name"
    t.text "description"
    t.decimal "rating", precision: 3, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_high_rating_broadcast_time"
    t.string "auth0_id", null: false
    t.index ["email"], name: "index_users_on_email"
    t.index ["github_name"], name: "index_users_on_github_name"
    t.index ["name"], name: "index_users_on_name"
    t.index ["rating"], name: "index_users_on_rating"
  end

  add_foreign_key "ratings", "users", column: "ratee_id"
  add_foreign_key "ratings", "users", column: "rater_id"
end
