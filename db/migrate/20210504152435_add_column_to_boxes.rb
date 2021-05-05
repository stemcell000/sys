class AddColumnToBoxes < ActiveRecord::Migration[6.0]
  def change
  	add_column :boxes, :container_name, :string
  	add_column :boxes, :shelf_name, :string
  	add_column :boxes, :shelf_rack_name, :string
  end
end
