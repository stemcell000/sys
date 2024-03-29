ActiveAdmin.register Vial do
#Import csv   
 active_admin_import validate: false,
              csv_options: {col_sep: ";" },
              before_batch_import: ->(importer) {   
                Vial.where(id: importer.values_at('id')).delete_all
              }

csv force_quotes: false, col_sep: ';', column_names: true do
  column :id
  column :name
  column :exit_date
  column :volume
  column :comment
  column :out
  column :barcode
  column (:batch) { |vial| vial.batch.nil? ? "" : vial.batch.id }
  column (:position) { |vial| vial.position.nil? ? "" : vial.position.id }
  column (:box) { |vial| vial.position.nil? ? "" : vial.position.box.id }
end              
#Add Button to site
end
