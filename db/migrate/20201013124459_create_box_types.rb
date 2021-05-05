class CreateBoxTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :box_types do |t|
      t.string "name"
      t.integer "max_position"
      t.text "comment"
      t.integer "vertical_max"
      t.integer "horizontal_max"
      t.timestamps null: false
    end
  end
end
