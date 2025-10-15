class HourlyRate < ApplicationRecord
  belongs_to :employee
  belongs_to :customer

  validates :hourly_rate, presence: true

  monetize :hourly_rate_cents
end
