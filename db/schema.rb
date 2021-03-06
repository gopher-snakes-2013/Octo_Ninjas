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

ActiveRecord::Schema.define(version: 20131024045436) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "movies", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "synopsis"
    t.string   "runtime"
    t.string   "critics_score"
    t.string   "audience_score"
    t.string   "pic"
    t.string   "rotten_id"
  end

  create_table "survey_movies", force: true do |t|
    t.integer  "survey_id"
    t.integer  "movie_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "surveys", force: true do |t|
    t.integer  "user_id"
    t.string   "survey_url"
    t.text     "survey_info"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "password_hash"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "votes", force: true do |t|
    t.integer  "survey_movie_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
