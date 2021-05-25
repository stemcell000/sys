class Container < ActiveRecord::Base
  after_create :generate_recap, :generate_racks
  after_update :generate_recap, :generate_racks

  belongs_to :location
  belongs_to :container_type
  has_many :shelves, dependent: :destroy
  has_many :shelf_racks, through: :shelves

  accepts_nested_attributes_for :shelves, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :location
  accepts_nested_attributes_for :container_type 

  validates :name, presence: true
  validates_associated :location, :container_type, :shelves
  
  def generate_recap
  location_name = self.location.nil? ? '-' : self.location.name
  building_name = self.location.nil? ? '-' : self.location.building.name
  block = "#{location_name} #{building_name}"
  self.update_columns(:recap => block)
  end

  def generate_racks
    k=0
    self.shelves.each_with_index do |shelf|
      #Reset shelf's racks
      shelf.shelf_racks.destroy_all
      #Creation of racks
      i=1
      shelf.rack_number.times{
        shelf_rack = ShelfRack.create(name: (k+i).to_s)
        #Creation of rack's positions
          j=1
          shelf.rack_position_number.times{
              position = RackPosition.create(name: j.to_s, nb: j)
              shelf_rack.rack_positions << position
              j+=1
                                        }
      shelf.shelf_racks << shelf_rack
      i+=1
      }
      k+=shelf.rack_number
    end
  end
end
