FactoryBot.define do
  factory :expense do
    employee
    customer
    date '2015-02-19'
    amount 250
    text 'Spesen'

    trait :default_associations do
      employee { Employee.first || association(:employee) }
      customer { Customer.first || association(:customer) }
    end
  end
end
