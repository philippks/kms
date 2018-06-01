FactoryBot.define do
  factory :employee do
    sequence(:name) { |i| "Mitarbeiter ##{i}" }
    initials 'HM'
    hourly_rate 150
    sequence(:email) { |i| "employee_#{i}@kms.ch" }
    password 'super secure password'
    password_confirmation 'super secure password'
  end
end
