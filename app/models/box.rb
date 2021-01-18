class Box < ActiveRecord::Base
  
  after_create :generate_recaps
  after_update :generate_recaps

  has_many :positions, :dependent => :destroy
  has_many :vials, through: :positions
  belongs_to :box_type
  belongs_to :rack_position

  validates :name, :box_type, :presence => true
  #validates :shelf, :presence => true
  
  accepts_nested_attributes_for :positions
  accepts_nested_attributes_for :rack_position
  
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
      |i| self.positions.create(nb: i, name: position_name[i])
    }
  end

  def generate_recaps
    box_name = self.name
    barcode = self.barcode.nil? ? 'unknown' : self.barcode
    box_type_name = self.box_type.nil? ? 'unknown' : self.box_type.name
    rack_position = self.rack_position.nil? ? 'unknown' : self.rack_position.name
    shelf_rack_name = self.rack_position.nil? ? 'unknown' : self.shelf_rack.name
    shelf_name = self.shelf_name.nil? ? 'unknown' : self.shelf.name
    container_name = self.rack_position.nil? ? 'unknown' : self.shelf.container.name
    comment = self.comment.nil? ? 'no comment' : self.comment

    block =
        " 
        <div class='col-md-12'>
          <div class='row'>
            <strong>Name : </strong> #{ box_name  }
          </div>
          <div class='row'>
            <strong>Barcode : </strong> #{ box_name  }
          </div>
          <div class='row'>
            <strong>Box type : </strong> #{ box_type_name  }
          </div>
          <div class='row'>
            <strong>Container : </strong> #{ container_name  }
          </div>
          <div class='row'>
            <strong>Shelf/column : </strong> #{ shelf_name }
          </div>
          <div class='row'>
            <strong>Rack : </strong> #{ shelf_rack_name }
          </div>
          <div class='row'>
            <strong>Position : </strong> #{ rack_position }
          </div>
          <div class='row'>
            <strong>Comment : </strong> #{ shelf_rack_name }
          </div>
          <div class='row'>
            <strong>Rack : </strong> #{ comment }
          </div>
          "

          self.update_columns(recap: block,
                              container_name: container_name,
                              shelf_name: shelf_name,
                              shelf_rack_name: shelf_rack_name
                               )
  end

  def set_color_from_position
    str=""
    str = self.rack_position.nil? ? "text-danger" : "text-success"
    return str
  end
  
end
