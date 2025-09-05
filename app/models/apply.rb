class Apply < ApplicationRecord
  belongs_to :job
  belongs_to :geek

  validates :job_id, presence: true
  validates :geek_id, presence: true
end
