class CreateTableBoxes < ActiveRecord::Migration[5.0]
  def change
     create_table "boxes", force: :cascade do |t|
      t.string   "name"
      t.string   "barcode"
      t.integer "box_type_id"
      t.integer "rack_position_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.text "comment"
      t.text "recap"
      t.integer "team_id"
      t.integer "color_id"
    end
  end
end
