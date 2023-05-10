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

ActiveRecord::Schema[7.0].define(version: 2023_05_10_022153) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "friendships", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id"
    t.uuid "friend_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.index ["friend_id"], name: "index_friendships_on_friend_id"
    t.index ["status"], name: "index_friendships_on_status"
    t.index ["user_id"], name: "index_friendships_on_user_id"
  end

  create_table "reviews", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "author_id"
    t.string "skipper_id"
    t.boolean "would_return"
    t.boolean "did_not_pay", default: false, null: false
    t.boolean "aggressive", default: false, null: false
    t.boolean "reckless", default: false, null: false
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "anonymity"
    t.boolean "good_teacher"
    t.boolean "paid_fuel"
    t.boolean "paid_retros"
    t.boolean "paid_food"
    t.index ["aggressive"], name: "index_reviews_on_aggressive"
    t.index ["author_id"], name: "index_reviews_on_author_id"
    t.index ["did_not_pay"], name: "index_reviews_on_did_not_pay"
    t.index ["good_teacher"], name: "index_reviews_on_good_teacher"
    t.index ["paid_food"], name: "index_reviews_on_paid_food"
    t.index ["paid_fuel"], name: "index_reviews_on_paid_fuel"
    t.index ["paid_retros"], name: "index_reviews_on_paid_retros"
    t.index ["reckless"], name: "index_reviews_on_reckless"
    t.index ["skipper_id"], name: "index_reviews_on_skipper_id"
    t.index ["would_return"], name: "index_reviews_on_would_return"
  end

  create_table "skippers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "firstname"
    t.string "lastname"
    t.string "boatname"
    t.string "city"
    t.boolean "active"
    t.uuid "creator_id"
    t.string "state"
    t.index ["active"], name: "index_skippers_on_active"
    t.index ["boatname"], name: "index_skippers_on_boatname"
    t.index ["city"], name: "index_skippers_on_city"
    t.index ["creator_id"], name: "index_skippers_on_creator_id"
    t.index ["firstname"], name: "index_skippers_on_firstname"
    t.index ["lastname"], name: "index_skippers_on_lastname"
    t.index ["state"], name: "index_skippers_on_state"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "unconfirmed_email"
    t.string "firstname"
    t.string "lastname"
    t.string "provider"
    t.string "uid"
    t.boolean "phantom", default: false
    t.boolean "admin"
    t.index ["admin"], name: "index_users_on_admin"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["firstname"], name: "index_users_on_firstname"
    t.index ["lastname"], name: "index_users_on_lastname"
    t.index ["phantom"], name: "index_users_on_phantom"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
