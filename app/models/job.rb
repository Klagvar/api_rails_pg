class Job < ApplicationRecord
  belongs_to :company
  has_many :applies

  validates :name, presence: true
  validates :place, presence: true
  validates :company_id, presence: true
end
