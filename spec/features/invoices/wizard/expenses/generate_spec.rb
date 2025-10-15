require 'rails_helper'

describe 'Manage Invoice Expenses' do
  let(:invoice) { create :invoice, :default_associations }
  let!(:expense) do
    create :expense, :default_associations, text: 'Something payed',
                                            date: 10.days.ago
  end

  before do
    sign_in invoice.employee
  end

  it 'Generate Invoice Expenses' do
    visit invoice_wizard_expenses_path(invoice)

    click_link 'Nebenkosten generieren'

    aggregate_failures 'generated invoice expense' do
      expect(Invoices::Expense.count).to eq 1
      expect(Invoices::Expense.pluck(:text)).to contain_exactly('Something payed')
      expect(Invoices::Expense.first.efforts).to eq [expense]
      expect(page).to have_current_path invoice_wizard_expenses_path(invoice), ignore_query: true
    end
  end
end
