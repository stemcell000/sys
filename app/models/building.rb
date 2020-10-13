class Building < DatabaseLabBase
  has_many :locations
  has_many :containers
  accepts_nested_attributes_for :locations
  accepts_nested_attributes_for :containers
end
