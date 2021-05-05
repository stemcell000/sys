ActiveAdmin.register Batch do

csv force_quotes: false, col_sep: ';', column_names: true do
  column :id
  column :name
  column :vial_nb
  column :description
  column :date
  column (:batch_type) { |batch| batch.batch_type.nil? ? "" : batch.batch_type.name }
end
end
