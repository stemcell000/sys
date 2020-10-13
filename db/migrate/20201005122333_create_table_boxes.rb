class CreateTableBoxes < ActiveRecord::Migration
  def change
     create_table "boxes", force: :cascade do |t|
      t.string   "name"
      t.string   "barcode"
      t.integer "shelf_id"
      t.integer "box_type_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
  end
end
