FactoryBot.define do
  factory :depreciation do
    note { "MyString" }
    date { "2019-03-01" }
    customer { nil }
    employee { nil }
    efforts { nil }
  end
end
