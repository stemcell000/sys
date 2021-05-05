class Team < ActiveRecord::Base
  
  scope :from_users, -> user_array {joins(:teams_users).where(:teams_users => {user_id: user_array})}
  
  has_and_belongs_to_many :users
  has_many :boxes
  belongs_to :department
  
  validates :name, presence: true
  validates :name, :format => { with: /\A[a-zA-Z0-9 ]+\z/ }

end
