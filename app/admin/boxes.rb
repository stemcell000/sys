ActiveAdmin.register Box do
#Import csv   
 active_admin_import validate: false,
              csv_options: {col_sep: ";" },
              before_batch_import: ->(importer) {   
                Box.where(id: importer.values_at('id')).delete_all
              }

csv force_quotes: false, col_sep: ';', column_names: true do
  column :id
  column :name
end

end
