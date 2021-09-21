# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_05_04_152435) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", id: :serial, force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.integer "resource_id"
    t.string "author_type"
    t.integer "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "batch_types", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "batches", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "batch_type_id"
    t.text "description"
    t.integer "passage_nb"
    t.string "patient_nb"
    t.integer "clone_nb"
    t.integer "user_id"
    t.integer "vial_nb"
  end

  create_table "box_types", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "max_position"
    t.text "comment"
    t.integer "vertical_max"
    t.integer "horizontal_max"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "boxes", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "barcode"
    t.integer "box_type_id"
    t.integer "rack_position_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "comment"
    t.text "recap"
    t.integer "team_id"
    t.integer "color_id"
    t.string "container_name"
    t.string "shelf_name"
    t.string "shelf_rack_name"
  end

  create_table "colors", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "container_types", id: :serial, force: :cascade do |t|
    t.string "name"
  end

  create_table "containers", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "barcode"
    t.integer "location_id"
    t.integer "container_type_id"
    t.text "recap"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "options", id: :serial, force: :cascade do |t|
    t.boolean "display_all", default: true
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "positions", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "box_id"
    t.integer "nb"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rack_positions", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "shelf_rack_id"
    t.integer "nb"
    t.boolean "available", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shelf_racks", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "shelf_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shelves", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "container_id"
    t.integer "rack_number"
    t.integer "rack_position_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teams", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teams_users", id: :serial, force: :cascade do |t|
    t.integer "team_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_teams_users_on_team_id"
    t.index ["user_id"], name: "index_teams_users_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "firstname"
    t.string "lastname"
    t.string "username"
    t.string "role"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "recap"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vials", id: :serial, force: :cascade do |t|
    t.string "name"
    t.float "volume"
    t.text "comment"
    t.integer "batch_id"
    t.boolean "out", default: false
    t.string "barcode"
    t.integer "position_id"
    t.text "recap"
    t.date "exit_date"
    t.date "freezing_date"
    t.integer "user_id"
  end

end
