class Vial < ActiveRecord::Base
  
  belongs_to :position
  belongs_to :team
  belongs_to :box
  
  accepts_nested_attributes_for :position
  accepts_nested_attributes_for :team
  
  #validations
  validates :name, :volume, :presence => true
  validates :name, length: { in: 2..25 }
  validates :name, length: { maximum: 25,
    too_long: "%{count} characters is the maximum allowed",
    minimum: 2, 
    too_sort: "%{count} characters is the minimum allowed" }
  validates :name, :format => { with: /\A[a-zA-Z0-9 ]+\z/ ,
    :message => 'no special characters, only letters and numbers' }
  
def generate_recap
  block = "#{self.name} <br />
            #{self.id} <br />
            #{self.barcode} <br />
            #{self.volume} µL <br />
            #{self.description} <br />
            #{self.comment} <br />
            #{self.box.name} <br />
            #{self.box.shelf.name} <br />
            #{self.box.shelf.container.name} <br />"
  self.update_columns(:recap => block)
end

def set_tube_status
  str = ""
  unless self.trash?
    case self.volume
      when 0
        str="/images/empty-med.png"
      when 0..50
        str="/images/full-med-very-low.png"
      when 50..100
        str="/images/full-med-low.png"
      when 100..500
        str="/images/full-med-half.png"
       when 500..1000
        str="/images/full-med-high.png"
      else
       str=  "/images/empty-med.png"
     end
   else
       str = "/images/trash.png"
   end
  return str
end

def set_draggable
  str=""
  unless self.trash?
    str= "draggable"
  end
  return str
end

def set_color_from_position
    str=""
    str = self.position.nil? ? "text-danger" : "text-success"
    return str
end
  
end
