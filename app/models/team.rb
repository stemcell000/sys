class Team < DatabaseLabBase
  
  scope :from_users, -> user_array {joins(:teams_users).where(:teams_users => {user_id: user_array})}
  
  has_and_belongs_to_many :users, join_table: "teams_users"
  belongs_to :type
  belongs_to :department
  
  validates :name, presence: true
  validates :acronym, presence: true
  validates :type, presence: true
  validates :department, presence: true
  
  accepts_nested_attributes_for :items, reject_if: :all_blank
end
