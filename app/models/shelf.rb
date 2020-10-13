class Shelf < ActiveRecord::Base
  belongs_to :container
  has_many :boxes
end
