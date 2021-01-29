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

ActiveRecord::Schema.define(version: 20210125095209) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "box_types", force: :cascade do |t|
    t.string   "name"
    t.integer  "max_position"
    t.text     "comment"
    t.integer  "vertical_max"
    t.integer  "horizontal_max"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "boxes", force: :cascade do |t|
    t.string   "name"
    t.string   "barcode"
    t.integer  "box_type_id"
    t.integer  "rack_position_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "container_name"
    t.string   "shelf_name"
    t.string   "shelf_rack_name"
    t.text     "comment"
    t.text     "recap"
    t.integer  "color_id"
  end

  create_table "colors", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "container_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "containers", force: :cascade do |t|
    t.string   "name"
    t.string   "barcode"
    t.integer  "location_id"
    t.integer  "container_type_id"
    t.text     "recap"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "options", force: :cascade do |t|
    t.boolean  "display_all", default: true
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "positions", force: :cascade do |t|
    t.string   "name"
    t.integer  "box_id"
    t.integer  "nb"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rack_positions", force: :cascade do |t|
    t.string   "name"
    t.integer  "shelf_rack_id"
    t.integer  "nb"
    t.boolean  "available",     default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shelf_racks", force: :cascade do |t|
    t.string   "name"
    t.integer  "shelf_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shelves", force: :cascade do |t|
    t.string   "name"
    t.integer  "container_id"
    t.integer  "rack_number"
    t.integer  "rack_position_number"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.string   "acronym"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teams_users", force: :cascade do |t|
    t.integer  "team_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "teams_users", ["team_id"], name: "index_teams_users_on_team_id", using: :btree
  add_index "teams_users", ["user_id"], name: "index_teams_users_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "firstname"
    t.string   "lastname"
    t.string   "username"
    t.string   "role"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "vials", force: :cascade do |t|
    t.string  "name"
    t.date    "date"
    t.float   "volume"
    t.text    "comment"
    t.integer "type_id"
    t.boolean "trash"
    t.string  "barcode"
    t.integer "position_id"
    t.integer "team_id"
    t.text    "recap"
    t.text    "description"
  end

end
