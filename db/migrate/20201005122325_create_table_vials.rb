class CreateTableVials < ActiveRecord::Migration
  def up
    create_table :vials do |t|
      t.string "name"
      t.date "date"
      t.float "volume"
      t.text "comment"
      t.integer "type_id"
      t.boolean "trash", default: false
      t.string "barcode"
      t.integer "position_id"
      t.integer "team_id"
      t.text "recap"
      t.text "description"
      t.date "date_of_thawing"
    end
  end
  
  def down
    drop_table :vials
  end
    
end
