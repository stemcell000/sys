class Color < ActiveRecord::Base
	has_many :boxes
	accepts_nested_attributes_for :boxes
end
