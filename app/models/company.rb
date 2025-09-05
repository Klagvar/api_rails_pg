class Company < ApplicationRecord
  has_many :jobs

  validates :name, presence: true
  validates :location, presence: true

  def delete_company
    update(deleted: true)
  end
end
