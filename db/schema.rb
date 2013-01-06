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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130106171956) do

  create_table "foursquare_users", :force => true do |t|
    t.string   "foursquare_id"
    t.string   "access_token"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "name"
    t.string   "email"
    t.string   "phone"
  end

  add_index "foursquare_users", ["foursquare_id"], :name => "index_foursquare_users_on_foursquare_id"

  create_table "itineraries", :force => true do |t|
    t.integer  "foursquare_user_id"
    t.string   "checkin_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.boolean  "approved"
    t.boolean  "demo"
    t.string   "zip"
    t.string   "tz_offset"
  end

  create_table "stops", :force => true do |t|
    t.integer  "itinerary_id"
    t.string   "name"
    t.string   "venue_id"
    t.datetime "time_to_post"
    t.boolean  "complete"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

end
