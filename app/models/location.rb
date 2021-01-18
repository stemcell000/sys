class Location < DatabaseLabBase
  has_many :containers
  belongs_to :building
  accepts_nested_attributes_for :containers  
  accepts_nested_attributes_for :building

  validates :name, presence: true
end
