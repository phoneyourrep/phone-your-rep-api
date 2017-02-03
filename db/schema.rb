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

ActiveRecord::Schema.define(version: 20170203030745) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "district_geoms", force: :cascade do |t|
    t.integer  "district_id"
    t.string   "full_code"
    t.geometry "geom",        limit: {:srid=>3857, :type=>"geometry"}
    t.index ["district_id"], name: "index_district_geoms_on_district_id", using: :btree
  end

  create_table "districts", force: :cascade do |t|
    t.string  "code"
    t.string  "state_code"
    t.string  "full_code"
    t.integer "requests",   default: 0
  end

  create_table "impressions", force: :cascade do |t|
    t.string   "impressionable_type"
    t.integer  "impressionable_id"
    t.integer  "user_id"
    t.string   "controller_name"
    t.string   "action_name"
    t.string   "view_name"
    t.string   "request_hash"
    t.string   "ip_address"
    t.string   "session_hash"
    t.text     "message"
    t.text     "referrer"
    t.text     "params"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["controller_name", "action_name", "ip_address"], name: "controlleraction_ip_index", using: :btree
    t.index ["controller_name", "action_name", "request_hash"], name: "controlleraction_request_index", using: :btree
    t.index ["controller_name", "action_name", "session_hash"], name: "controlleraction_session_index", using: :btree
    t.index ["impressionable_type", "impressionable_id", "ip_address"], name: "poly_ip_index", using: :btree
    t.index ["impressionable_type", "impressionable_id", "params"], name: "poly_params_request_index", using: :btree
    t.index ["impressionable_type", "impressionable_id", "request_hash"], name: "poly_request_index", using: :btree
    t.index ["impressionable_type", "impressionable_id", "session_hash"], name: "poly_session_index", using: :btree
    t.index ["impressionable_type", "message", "impressionable_id"], name: "impressionable_type_message_index", using: :btree
    t.index ["user_id"], name: "index_impressions_on_user_id", using: :btree
  end

  create_table "issues", force: :cascade do |t|
    t.string   "issue_type",                         null: false
    t.boolean  "resolved",           default: false
    t.integer  "office_location_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.index ["office_location_id"], name: "index_issues_on_office_location_id", using: :btree
  end

  create_table "office_locations", force: :cascade do |t|
    t.string   "office_type"
    t.string   "suite"
    t.string   "phone"
    t.string   "address"
    t.string   "building"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.float    "latitude"
    t.float    "longitude"
    t.geometry "lonlat",        limit: {:srid=>0, :type=>"point"}
    t.datetime "created_at",                                                   null: false
    t.datetime "updated_at",                                                   null: false
    t.string   "bioguide_id"
    t.string   "fax"
    t.string   "hours"
    t.string   "qr_code_uid"
    t.string   "qr_code_name"
    t.integer  "downloads",                                        default: 0
    t.string   "v_card_simple"
  end

  create_table "reps", force: :cascade do |t|
    t.integer  "district_id"
    t.integer  "state_id"
    t.string   "role"
    t.string   "official_full"
    t.string   "last"
    t.string   "first"
    t.string   "middle"
    t.string   "suffix"
    t.string   "party"
    t.string   "contact_form"
    t.string   "url"
    t.string   "twitter"
    t.string   "facebook"
    t.string   "youtube"
    t.string   "googleplus"
    t.text     "committees"
    t.string   "senate_class"
    t.string   "bioguide_id"
    t.string   "photo"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "nickname"
    t.string   "instagram"
    t.string   "instagram_id"
    t.string   "facebook_id"
    t.string   "youtube_id"
    t.string   "twitter_id"
    t.index ["district_id"], name: "index_reps_on_district_id", using: :btree
    t.index ["state_id"], name: "index_reps_on_state_id", using: :btree
  end

  create_table "state_geoms", force: :cascade do |t|
    t.integer  "state_id"
    t.string   "state_code"
    t.geometry "geom",       limit: {:srid=>3857, :type=>"geometry"}
    t.index ["state_id"], name: "index_state_geoms_on_state_id", using: :btree
  end

  create_table "states", force: :cascade do |t|
    t.string "state_code"
    t.string "name"
    t.string "abbr"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                             default: "", null: false
    t.string   "encrypted_password",                default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "authentication_token",   limit: 30
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "v_cards", force: :cascade do |t|
    t.text     "data"
    t.integer  "office_location_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["office_location_id"], name: "index_v_cards_on_office_location_id", using: :btree
  end

  create_table "zcta", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "zcta"
  end

  create_table "zcta_districts", force: :cascade do |t|
    t.integer  "zcta_id"
    t.integer  "district_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["district_id"], name: "index_zcta_districts_on_district_id", using: :btree
    t.index ["zcta_id"], name: "index_zcta_districts_on_zcta_id", using: :btree
  end

  add_foreign_key "district_geoms", "districts"
  add_foreign_key "state_geoms", "states"
  add_foreign_key "v_cards", "office_locations"
  add_foreign_key "zcta_districts", "districts"
  add_foreign_key "zcta_districts", "zcta", column: "zcta_id"
end
