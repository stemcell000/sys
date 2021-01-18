class Shelf < ActiveRecord::Base
  belongs_to :container
  has_many :shelf_racks, dependent: :destroy
  has_many :boxes, through: :shelf_racks

  accepts_nested_attributes_for :shelf_racks, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :container

  validates :rack_number, :name, presence: true

end
