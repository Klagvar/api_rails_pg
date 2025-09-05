class Geek < ApplicationRecord
  has_many :applies

  validates :name, presence: true
  validates :stack, presence: true
end
