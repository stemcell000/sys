class CreateTableShelves < ActiveRecord::Migration[5.0]
  def change
    create_table :shelves do |t|
      t.string "name"
      t.integer "container_id"
      t.integer "rack_number"
      t.integer "rack_position_number"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
  end
end
