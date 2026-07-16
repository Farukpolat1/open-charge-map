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

ActiveRecord::Schema[8.1].define(version: 2026_07_16_121812) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "favorites", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "station_identifier"
    t.decimal "station_lat"
    t.decimal "station_lng"
    t.string "station_title"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id", "station_identifier"], name: "index_favorites_on_user_id_and_station_identifier", unique: true
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "station_ratings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "liked", null: false
    t.string "station_identifier", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id", "station_identifier"], name: "index_station_ratings_on_user_id_and_station_identifier", unique: true
    t.index ["user_id"], name: "index_station_ratings_on_user_id"
  end

  create_table "stations", force: :cascade do |t|
    t.string "address_line"
    t.string "connector_type"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "district"
    t.decimal "latitude"
    t.string "level"
    t.decimal "longitude"
    t.string "province"
    t.integer "quantity"
    t.string "title"
    t.string "town"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_stations_on_user_id"
  end

  create_table "status_reports", force: :cascade do |t|
    t.text "comment"
    t.datetime "created_at", null: false
    t.string "station_identifier", null: false
    t.string "status", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["station_identifier", "created_at"], name: "index_status_reports_on_station_identifier_and_created_at"
    t.index ["user_id"], name: "index_status_reports_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "name"
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "favorites", "users"
  add_foreign_key "sessions", "users"
  add_foreign_key "station_ratings", "users"
  add_foreign_key "stations", "users"
  add_foreign_key "status_reports", "users"
end
