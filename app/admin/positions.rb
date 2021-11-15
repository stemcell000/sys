ActiveAdmin.register Position do

#Import csv   
 active_admin_import validate: false,
              csv_options: {col_sep: ";" },
              before_batch_import: ->(importer) {   
                Position.where(id: importer.values_at('id')).delete_all
              }
  
csv force_quotes: false, col_sep: ';', column_names: true do
  column :id
  column :name
  column :nb
  column :box_id
end  

end
