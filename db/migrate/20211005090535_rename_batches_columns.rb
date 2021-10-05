class RenameBatchesColumns < ActiveRecord::Migration[6.0]
  def change
    rename_column :batches, :clone_nb, :clonenb
    rename_column :batches, :patient_nb, :patientnb
    rename_column :batches, :passage_nb, :passagenb
  end
end
