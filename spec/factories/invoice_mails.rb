FactoryBot.define do
  factory :invoice_mail, class: Invoices::Mail do
    body { 'Some email' }
  end
end
