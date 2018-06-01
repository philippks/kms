class HourlyRate < ActiveRecord::Base
  belongs_to :employee
  belongs_to :customer

  validates :hourly_rate, :employee, :customer, presence: true

  monetize :hourly_rate_cents
end
