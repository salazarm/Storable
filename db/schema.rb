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

ActiveRecord::Schema.define(:version => 20130506203127) do

  create_table "conversations", :force => true do |t|
    t.integer  "renter_id"
    t.integer  "host_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "listing_id"
    t.boolean  "host_starred"
    t.boolean  "host_read"
    t.boolean  "renter_starred"
    t.boolean  "renter_read"
    t.boolean  "request_submitted"
  end

  create_table "images", :force => true do |t|
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "location"
  end

  create_table "listings", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "user_id"
    t.integer  "price"
    t.float    "size"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "locations", :force => true do |t|
    t.integer  "listing_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.float    "latitude"
    t.float    "longitude"
  end

  create_table "messages", :force => true do |t|
    t.integer  "conversation_id"
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "reserved_dates", :force => true do |t|
    t.integer  "listing_id"
    t.integer  "renter_id"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "reviews", :force => true do |t|
    t.integer  "reviewer_id"
    t.text     "content"
    t.integer  "overall_rating"
    t.integer  "quality_rating"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.integer  "transaction_id"
    t.integer  "location_rating"
    t.integer  "price_rating"
    t.integer  "reviewee_id"
    t.integer  "timeliness_rating"
    t.integer  "responsiveness_rating"
    t.string   "type"
    t.integer  "listing_id"
  end

  create_table "transaction_listings", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "user_id"
    t.integer  "price"
    t.float    "size"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "listing_id"
    t.integer  "transaction_id"
  end

  create_table "transactions", :force => true do |t|
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "host_id"
    t.integer  "renter_id"
    t.boolean  "host_accepted"
    t.string   "stripeToken"
    t.date     "start_date"
    t.date     "end_date"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.text     "about"
    t.string   "first_name"
    t.string   "last_name"
  end

end
