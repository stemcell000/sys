class Team < ActiveRecord::Base
  
  scope :from_users, -> user_array {joins(:teams_users).where(:teams_users => {user_id: user_array})}
  
  has_and_belongs_to_many :users
  has_many :vials
  belongs_to :department
  
  validates :name, presence: true
  validates :acronym, presence: true
  
  accepts_nested_attributes_for :vials, reject_if: :all_blank
end
