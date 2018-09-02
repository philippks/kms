FactoryBot.define do
  factory :absence do
    employee
    from_date { '2015-02-20' }
    to_date { '2015-02-20' }
    hours { 1.5 }
    reason { :doctor }
    text { 'Bein gebrochen' }

    trait :default_associations do
      employee { Employee.first || association(:employee) }
    end
  end
end
