class Position < ActiveRecord::Base
  belongs_to :box
  has_one :vial
  scope :is_empty, -> {includes(:vial).where(vials: {position_id: nil})}
end
