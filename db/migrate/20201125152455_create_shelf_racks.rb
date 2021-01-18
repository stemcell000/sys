class CreateShelfRacks < ActiveRecord::Migration
  def change
    create_table :shelf_racks do |t|
    	t.string :name
    	t.integer :shelf_id
      t.timestamps null: false
    end
  end
end
