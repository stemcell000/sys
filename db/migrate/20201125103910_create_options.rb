class CreateOptions < ActiveRecord::Migration[5.0]
   def change
    create_table :options do |t|
      t.boolean :display_all, :default => true
      t.integer :user_id
      t.timestamps
    end
  end
end
