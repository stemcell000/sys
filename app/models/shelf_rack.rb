class ShelfRack < ActiveRecord::Base
	belongs_to :shelf
	has_many :rack_positions, dependent: :destroy
	has_many :box, through: :rack_positions

	accepts_nested_attributes_for :rack_positions, allow_destroy: true, reject_if: :all_blank
end
