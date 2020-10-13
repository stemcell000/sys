class Box < ActiveRecord::Base
  has_many :positions, :dependent => :destroy
  has_many :vials, through: :positions
  belongs_to :box_type
  belongs_to :shelf
  validates :name, :box_type, :presence => true
  #validates :shelf, :presence => true
  accepts_nested_attributes_for :positions
  accepts_nested_attributes_for :shelf
  
  def generate_positions
    position_name = []
    max_position = self.box_type.vertical_max*self.box_type.horizontal_max
    
    #horizontal_max = nb de lignes
    #vertical_max = nb de colonnes
    
    rows = ('a'..'z').to_a[0..(self.box_type.vertical_max-1)]
    cols = (1..26).to_a[0..(self.box_type.horizontal_max-1)]
    #
    rows.each do |r|
      cols.each do|c|
        position_name.push("#{r}#{c}")
      end
    end
    #
    total_range = (0..(max_position-1)).to_a
    total_range.each{
      |i| self.positions.create(nb: i, name: position_name[i], box_name: self.name)
    }
  end
  
end
