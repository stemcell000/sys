class ContainerType < ActiveRecord::Base
	has_many :containers
	accepts_nested_attributes_for :containers

	validates :name, presence: true
end