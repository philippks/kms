FactoryBot.define do
  factory :invoice_expense, class: Invoices::Expense do
    text 'Dies und das gemacht'

    trait :with_associations do
      invoice
    end
  end
end
