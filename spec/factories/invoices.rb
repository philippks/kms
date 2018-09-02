FactoryBot.define do
  factory :invoice, class: Invoice do
    date { '2015-03-22' }
    vat_rate { 0.015 }
    employee { nil }
    customer { nil }
    confidential { false }

    trait :with_associations do
      employee
      customer
    end

    trait :default_associations do
      employee { Employee.first || association(:employee) }
      customer { Customer.first || association(:customer) }
    end
  end
end
