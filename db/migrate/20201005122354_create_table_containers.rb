class CreateTableContainers < ActiveRecord::Migration[5.0]
  def change
    create_table :containers do |t|
      t.string "name"
      t.string "barcode"
      t.integer "location_id"
      t.integer "container_type_id"
      t.text "recap"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
  end
end
