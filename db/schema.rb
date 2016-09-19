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

ActiveRecord::Schema.define(version: 20160909160022) do

  create_table "airports", force: :cascade do |t|
    t.string   "name"
    t.string   "continent"
    t.string   "country"
    t.string   "state_and_code"
    t.string   "airport_type"
    t.integer  "rating"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "bookings", force: :cascade do |t|
    t.string   "reference_id"
    t.integer  "total_cost"
    t.string   "paid"
    t.string   "travel_class"
    t.integer  "flight_id"
    t.integer  "user_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "bookings", ["flight_id"], name: "index_bookings_on_flight_id"
  add_index "bookings", ["user_id"], name: "index_bookings_on_user_id"

  create_table "flights", force: :cascade do |t|
    t.integer  "airport_id"
    t.string   "origin"
    t.string   "destination"
    t.integer  "seat"
    t.datetime "departure"
    t.datetime "arrival"
    t.string   "airline"
    t.string   "flight_code"
    t.string   "flight_type"
    t.integer  "flight_cost"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "flights", ["airport_id"], name: "index_flights_on_airport_id"

  create_table "passengers", force: :cascade do |t|
    t.integer  "booking_id"
    t.string   "title"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "email"
    t.string   "telephone"
    t.string   "nationality"
    t.string   "luggage"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "passengers", ["booking_id"], name: "index_passengers_on_booking_id"

  create_table "users", force: :cascade do |t|
    t.string   "title"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "email"
    t.string   "telephone"
    t.string   "username"
    t.string   "password"
    t.boolean  "admin_user"
    t.boolean  "subscription"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

end
