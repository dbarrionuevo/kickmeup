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

ActiveRecord::Schema.define(version: 20130612200809) do

  create_table "idea_kickups", force: true do |t|
    t.integer  "user_id"
    t.integer  "idea_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "idea_kickups", ["idea_id"], name: "index_idea_kickups_on_idea_id"
  add_index "idea_kickups", ["user_id"], name: "index_idea_kickups_on_user_id"

  create_table "ideas", force: true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.string   "description"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "kickups",     default: 0
  end

  add_index "ideas", ["slug"], name: "index_ideas_on_slug", unique: true
  add_index "ideas", ["user_id"], name: "index_ideas_on_user_id"

  create_table "users", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "nickname"
    t.string   "email"
    t.string   "provider_image"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["slug"], name: "index_users_on_slug", unique: true

end
