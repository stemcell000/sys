class Vial < ActiveRecord::Base
  
  after_create :generate_recap
  after_update :generate_recap

  belongs_to :position
  has_one :box, through: :position
  belongs_to :batch
  belongs_to :user
  
  accepts_nested_attributes_for :position, :batch
  
  #validations
  validates :name, :batch_id, presence: true
  validates :name, uniqueness: true
  validates :name, length: { in: 2..25 }
  validates :comment, length: { maximum: 500 }, allow_blank: true
  validates :name, :comment, :format => { with: /\A[a-zA-Z0-9 ._-]*\z/ ,
    :message => 'no special characters, only letters and numbers'}
  
def generate_recap
  block = "#{self.name.nil? ? "": self.name}<br />
            #{self.id.nil? ? "": self.id}<br />
            #{self.barcode.nil? ? "": self.barcode}<br />
            #{self.volume.nil? ? "": self.volume} µL<br />
            #{self.comment.nil? ? "": self.comment}<br />
            #{self.freezing_date.nil? ? "" : self.freezing_date}<br />
            #{self.user.nil? ? "" : self.user.full_name}<br />
            #{self.box.nil? ? "unsorted": self.box.name}<br />
            #{self.position.nil? ? "unsorted": self.position.name}<br />"
  self.update_columns(:recap => block)
end

def set_draggable
  str=""
  unless self.out?
    str= "draggable"
  end
  return str
end

def set_color_from_position
    str=""
    str = self.position.nil? ? "text-danger" : "text-success"
    return str
end

def set_color_from_status
  str=""
      str = self.out==true ? "text-danger" : ""
    return str
end
  
end
