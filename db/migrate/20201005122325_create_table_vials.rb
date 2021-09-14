class CreateTableVials < ActiveRecord::Migration[5.0]
  def up
    create_table :vials do |t|
      t.string :name
      t.float :volume
      t.text :comment
      t.integer :batch_id
      t.boolean :out, default: false
      t.string :barcode
      t.integer :position_id
      t.text :recap
      t.date :exit_date
      t.date :freezing_date
      t.integer :user_id
    end
  end
  
  def down
    drop_table :vials
  end
    
end
