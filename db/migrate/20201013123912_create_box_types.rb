class CreateBoxTypes < ActiveRecord::Migration
  def change
    create_table :box_types do |t|
      t.string "name"
      t.integer "max_position"
      t.text "comment"
      t.integer "vertical_max"
      t.integer "horizontal_max"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
  end
end
