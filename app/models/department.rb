class Department < DatabaseLabBase
  
  belongs_to :organization
  has_many :teams
  validates :name, presence: true
  
end
