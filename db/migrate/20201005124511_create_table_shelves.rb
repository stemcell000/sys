class CreateTableShelves < ActiveRecord::Migration
  def change
    create_table :shelves do |t|
      t.string "name"
      t.string "name"
      t.integer "container_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
  end
end
