ActiveAdmin.register Batch do

#Import csv   
 active_admin_import validate: false,
              csv_options: {col_sep: ";" },
              #headers_rewrites: { 'batch_type' => :batch_type_id},
              before_batch_import: ->(importer) {   
                Batch.where(id: importer.values_at('id')).delete_all
              }


permit_params :name, :vial_nb, :description, :batch_type_id, :passagenb, :patientnb, :clonenb, :corrected, :technique 

csv force_quotes: false, col_sep: ';', column_names: true do
  column :id
  column :name
  column :vial_nb
  column :description
  column (:batch_type) { |batch| batch.batch_type.nil? ? "" : batch.batch_type.name }
end
end
