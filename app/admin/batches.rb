ActiveAdmin.register Batch do

#Import csv   
 active_admin_import validate: true,
              csv_options: {col_sep: ";" },
               before_batch_import: ->(importer) {

                Batch.where(id: importer.values_at('id')).delete_all
              }


csv force_quotes: false, col_sep: ';', column_names: true do
  column :id
  column :name
  column :vial_nb
  column :description
  column :date
  column (:batch_type) { |batch| batch.batch_type.nil? ? "" : batch.batch_type.name }
end
end
