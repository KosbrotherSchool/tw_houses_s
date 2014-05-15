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

ActiveRecord::Schema.define(version: 20140515114212) do

  create_table "building_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "counties", force: true do |t|
    t.string   "name"
    t.integer  "county_web_id"
    t.integer  "county_house_num"
    t.integer  "current_house_page_num"
    t.integer  "county_rent_num"
    t.integer  "current_rent_page_num"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ground_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "houses", force: true do |t|
    t.string   "title"
    t.string   "promote_pic_link"
    t.string   "link"
    t.integer  "price"
    t.string   "address"
    t.decimal  "square_price",       precision: 10, scale: 2
    t.decimal  "total_area",         precision: 10, scale: 2
    t.integer  "layer"
    t.integer  "total_lyaers"
    t.integer  "building_age"
    t.integer  "rooms"
    t.integer  "living_rooms"
    t.integer  "rest_rooms"
    t.integer  "balconies"
    t.decimal  "parking_area",       precision: 10, scale: 2
    t.string   "parking_type"
    t.decimal  "x_long",             precision: 15, scale: 10
    t.decimal  "y_lat",              precision: 15, scale: 10
    t.integer  "guard_price"
    t.string   "orientation"
    t.boolean  "is_renting"
    t.string   "ground_explanation"
    t.string   "living_explanation"
    t.text     "feature_html"
    t.string   "verder_name"
    t.string   "phone_link"
    t.integer  "phone_number"
    t.integer  "building_type_id"
    t.integer  "ground_type_id"
    t.integer  "county_id"
    t.integer  "town_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_show"
    t.boolean  "is_keep_show"
    t.boolean  "is_need_update"
    t.integer  "create_date_num"
  end

  create_table "pictures", force: true do |t|
    t.integer  "house_id"
    t.string   "picture_link"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "proxies", force: true do |t|
    t.string   "proxy_addr"
    t.integer  "proxy_port"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "raw_lists", force: true do |t|
    t.text     "html",       limit: 2147483647
    t.integer  "page_num"
    t.integer  "county_id"
    t.boolean  "is_parsed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "raw_rent_lists", force: true do |t|
    t.text     "html",       limit: 2147483647
    t.integer  "page_num"
    t.integer  "county_id"
    t.boolean  "is_parsed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rent_houses", force: true do |t|
    t.string   "title"
    t.string   "promote_pic_link"
    t.string   "link"
    t.integer  "price"
    t.string   "address"
    t.string   "deposit"
    t.decimal  "rent_area",          precision: 10, scale: 2
    t.integer  "layer"
    t.integer  "total_lyaers"
    t.integer  "building_age"
    t.integer  "rooms"
    t.integer  "living_rooms"
    t.integer  "rest_rooms"
    t.integer  "balconies"
    t.string   "parking_type"
    t.decimal  "x_long",             precision: 15, scale: 10
    t.decimal  "y_lat",              precision: 15, scale: 10
    t.integer  "guard_price"
    t.string   "mint_rent_time"
    t.boolean  "is_cooking"
    t.boolean  "is_pet"
    t.string   "identity"
    t.string   "sexual_restriction"
    t.string   "orientation"
    t.string   "furniture"
    t.string   "equipment"
    t.string   "living_explanation"
    t.string   "communication"
    t.text     "feature_html"
    t.string   "verder_name"
    t.string   "phone_link"
    t.string   "phone_number"
    t.integer  "building_type_id"
    t.integer  "rent_type_id"
    t.integer  "county_id"
    t.integer  "town_id"
    t.boolean  "is_show"
    t.boolean  "is_keep_show"
    t.boolean  "is_need_update"
    t.integer  "create_date_num"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "xy_change",          precision: 15, scale: 10
  end

  create_table "rent_pictures", force: true do |t|
    t.integer  "rent_id"
    t.string   "picture_link"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rent_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "towns", force: true do |t|
    t.string   "name"
    t.integer  "county_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "x_lng",      precision: 15, scale: 10
    t.decimal  "y_lat",      precision: 15, scale: 10
  end

end
