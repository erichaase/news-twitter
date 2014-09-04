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

ActiveRecord::Schema.define(version: 20140904161030) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "posts", force: true do |t|
    t.string   "source"
    t.integer  "tid",           limit: 8
    t.datetime "published"
    t.datetime "updated"
    t.datetime "read"
    t.datetime "clicked"
    t.string   "text"
    t.integer  "nfavorite"
    t.integer  "nretweet"
    t.integer  "score"
    t.text     "json"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "score_decayed"
  end

  add_index "posts", ["published"], name: "index_posts_on_published", using: :btree
  add_index "posts", ["read"], name: "index_posts_on_read", using: :btree
  add_index "posts", ["score_decayed"], name: "index_posts_on_score_decayed", using: :btree
  add_index "posts", ["source"], name: "index_posts_on_source", using: :btree
  add_index "posts", ["tid"], name: "index_posts_on_tid", using: :btree

end
