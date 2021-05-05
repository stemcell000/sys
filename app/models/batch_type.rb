class BatchType < ActiveRecord::Base
	has_many :batches
  
  accepts_nested_attributes_for :batches
end
