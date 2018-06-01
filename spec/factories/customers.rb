FactoryBot.define do
  factory :customer do
    sequence(:name) { |i| "Kunde ##{i}" }
    address 'Meiersstrasse 10\n3791 Hanshausen'
    confidential_title 'Hansi'
    customer_group nil

    trait :not_chargeable do
      customer_group { build :customer_group, not_chargeable: true }
    end
  end
end
