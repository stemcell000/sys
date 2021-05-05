class CreateBatch < ActiveRecord::Migration[5.0]
  def change
    create_table :batches do |t|
      t.string :name
      t.integer :batch_type_id
      t.text :description
      t.date :date
      t.integer :user_id
      t.integer :vial_nb
    end
  end
end
