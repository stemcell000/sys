class CreateTableContainerTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :container_types do |t|
      t.string :name
    end
  end
end
