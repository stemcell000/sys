class RackPosition < ActiveRecord::Base
belongs_to :shelf_rack
has_one :box
end