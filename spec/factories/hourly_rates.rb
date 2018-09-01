FactoryBot.define do
  factory :hourly_rate do
    employee
    customer
    hourly_rate { 150 }
  end
end
