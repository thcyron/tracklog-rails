# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20130310162618) do

  create_table "logs", force: true do |t|
    t.string   "name"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "logs_tags", id: false, force: true do |t|
    t.integer "log_id", null: false
    t.integer "tag_id", null: false
  end

  add_index "logs_tags", ["log_id", "tag_id"], name: "index_logs_tags_on_log_id_and_tag_id", unique: true

  create_table "tags", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["name"], name: "index_tags_on_name"

  create_table "trackpoints", force: true do |t|
    t.integer  "track_id"
    t.float    "latitude",  null: false
    t.float    "longitude", null: false
    t.float    "elevation"
    t.datetime "time",      null: false
  end

  add_index "trackpoints", ["track_id"], name: "index_trackpoints_on_track_id"

  create_table "tracks", force: true do |t|
    t.integer  "log_id"
    t.float    "distance"
    t.float    "duration"
    t.float    "overall_average_speed"
    t.float    "max_speed"
    t.float    "ascent"
    t.float    "descent"
    t.float    "min_elevation"
    t.float    "max_elevation"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "moving_time"
    t.float    "stopped_time"
    t.float    "moving_average_speed"
    t.string   "name"
  end

  add_index "tracks", ["log_id"], name: "index_tracks_on_log_id"

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "name"
    t.string   "password_digest"
    t.boolean  "is_admin",        default: false
    t.datetime "last_login_at"
    t.string   "distance_units"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["username"], name: "index_users_on_username"

end
