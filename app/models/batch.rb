class Batch < ActiveRecord::Base

	has_many :vials, dependent: :destroy
	belongs_to :batch_type
	belongs_to :user

	accepts_nested_attributes_for :vials,:allow_destroy => true, reject_if: :all_blank

  ransacker :clone_nb do
    Arel.sql("to_char(\"#{:batches}\".\"clone_nb\", '99999')")
  end

  #after_create :generate_recap
  #after_update :generate_recap

	#validations
  validates :name, :batch_type_id, :presence => true
  validates :name, length: { in: 2..25 }
  validates :name, uniqueness: true
  validates :description, length: { maximum: 500 }, allow_blank: true
  validates :name, length: { maximum: 25,
    too_long: "%{count} characters is the maximum allowed",
    minimum: 2}
  validates :vial_nb, presence: true, on: :create

end