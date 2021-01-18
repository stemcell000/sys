class CreateRackPositions < ActiveRecord::Migration
  def change
    create_table :rack_positions do |t|
    	t.string :name
    	t.integer :shelf_rack_id
    	t.integer :nb
    	t.boolean :available, default: true
    	t.timestamps
    end
  end
end
