FactoryBot.define do
  factory :activity do
    text 'Steuererklärung ausgefüllt'
    note ''
    employee nil
    customer nil
    activity_category
    hours '2.5'
    hourly_rate 150
    date '2015-02-18'

    trait :with_associations do
      employee
      customer
    end

    trait :default_associations do
      employee { Employee.first || association(:employee) }
      customer { Customer.first || association(:customer) }
    end

    trait :charged do
      invoice_effort { build :invoice_activity, :with_associations }
    end
  end
end
