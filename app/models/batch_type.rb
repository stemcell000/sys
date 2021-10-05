class BatchType < ActiveRecord::Base
has_many :batches
has_many :vials, through: :batches
  
  accepts_nested_attributes_for :batches
end
