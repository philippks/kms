require 'rails_helper'

feature 'Manage Invoice Expenses' do
  let(:invoice) { create :invoice, :default_associations }
  let!(:expense) do
    create :expense, :default_associations, text: 'Something payed',
                                            date: 10.day.ago
  end

  before do
    sign_in invoice.employee
  end

  scenario 'Generate Invoice Expenses' do
    visit invoice_wizard_expenses_path(invoice)

    click_link 'Nebenkosten generieren'

    aggregate_failures 'generated invoice expense' do
      expect(Invoices::Expense.count).to eq 1
      expect(Invoices::Expense.pluck(:text)).to match_array ['Something payed']
      expect(Invoices::Expense.first.efforts).to eq [expense]
      expect(current_path).to eq invoice_wizard_expenses_path(invoice)
    end
  end
end
