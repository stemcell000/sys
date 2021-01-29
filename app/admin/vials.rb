ActiveAdmin.register Vial do
#Import csv   
 active_admin_import validate: false,
              csv_options: {col_sep: ";" },
              headers_rewrites: { 'box' => :box_id},
              before_batch_import: ->(importer) {
   
                Vial.where(id: importer.values_at('id')).delete_all
              }
csv force_quotes: false, col_sep: ';', column_names: true do
  column :id
  column :name
  column :position_id
  column :date
  column :volume
  column :created_at
  column :updated_at
  column :comment
  column :vol_unit_id
  column :trash
  column :barcode
  column :date_of_thawing
  column :date_of_freezing
  column :recap
end              
#Add Button to site
action_item do
  link_to "View Site", "/"
end

end
