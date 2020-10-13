class Container < ActiveRecord::Base
  belongs_to :location
  has_many :shelves
  
  accepts_nested_attributes_for :shelves
  accepts_nested_attributes_for :location 
  def generate_recap
  location_name = self.location.nil? ? '-' : self.location.name
  buiding_name = self.location.nil? ? '-' : self.location.building.name
  block = "#{location_name} #{building_name}"
  self.update_columns(:recap => block)
  end
  
end
