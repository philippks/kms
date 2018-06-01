FactoryBot.define do
  factory :payment, class: Invoices::Payment do
    date Date.current
    amount 200
  end
end
