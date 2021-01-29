class CreateTableBoxes < ActiveRecord::Migration
  def change
     create_table "boxes", force: :cascade do |t|
      t.string   "name"
      t.string   "barcode"
      t.integer "box_type_id"
      t.integer "rack_position_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string "container_name"
      t.string "shelf_name"
      t.string "shelf_rack_name"
      t.text "comment"
      t.text "recap"
      t.integer "color_id"
    end
  end
end
