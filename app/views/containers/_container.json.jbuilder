json.extract! container, :id, :name, :barcode
json.extract! location_name container.location do |location|
	json.(location, :id, :name)
end 
json.url container_url(container, format: :json)
