FactoryBot.define do
  factory :invoice_activity, class: Invoices::Activity do
    text { 'Dies und das gemacht' }

    trait :with_associations do
      invoice { build :invoice, :with_associations }
    end

    trait :default_associations do
      invoice { Invoice.first || association(:invoice, :default_associations) }
    end
  end
end
