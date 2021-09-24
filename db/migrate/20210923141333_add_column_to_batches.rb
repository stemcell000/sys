class AddColumnToBatches < ActiveRecord::Migration[6.0]
  def change
    add_column :batches, :culture, :string
    add_column :batches, :corrected, :boolean
    add_column :batches, :technique, :string
  end
end
