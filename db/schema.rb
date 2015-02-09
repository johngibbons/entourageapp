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

ActiveRecord::Schema.define(version: 20150209033138) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "relationships", force: :cascade do |t|
    t.integer  "liked_id"
    t.integer  "liker_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "relationships", ["liked_id"], name: "index_relationships_on_liked_id", using: :btree
  add_index "relationships", ["liker_id", "liked_id"], name: "index_relationships_on_liker_id_and_liked_id", unique: true, using: :btree
  add_index "relationships", ["liker_id"], name: "index_relationships_on_liker_id", using: :btree

  create_table "uploads", force: :cascade do |t|
    t.text     "tags"
    t.integer  "user_id"
    t.integer  "views",              default: 0
    t.integer  "downloads",          default: 0
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "likes_count",        default: 0
    t.boolean  "approved",           default: false
  end

  add_index "uploads", ["created_at"], name: "index_uploads_on_created_at", using: :btree
  add_index "uploads", ["downloads", "created_at"], name: "index_uploads_on_downloads_and_created_at", using: :btree
  add_index "uploads", ["likes_count", "created_at", "views", "downloads"], name: "weighted_score", using: :btree
  add_index "uploads", ["likes_count"], name: "index_uploads_on_likes_count", using: :btree
  add_index "uploads", ["tags"], name: "index_uploads_on_tags", using: :btree
  add_index "uploads", ["user_id", "created_at"], name: "index_uploads_on_user_id_and_created_at", using: :btree
  add_index "uploads", ["user_id"], name: "index_uploads_on_user_id", using: :btree
  add_index "uploads", ["views", "created_at"], name: "index_uploads_on_views_and_created_at", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin",             default: false
    t.string   "provider"
    t.string   "uid"
    t.string   "activation_digest"
    t.boolean  "activated",         default: false
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

  add_foreign_key "uploads", "users"
end
