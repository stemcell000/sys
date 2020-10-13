class CreateTablePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.string "name"
      t.integer "box_id"
      t.integer "nb"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
  end
end
