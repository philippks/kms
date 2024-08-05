require 'rails_helper'

describe 'Group Invoice Expenses' do
  let(:invoice) { create :invoice, :default_associations }

  let!(:invoice_expense) do
    create :invoice_expense, invoice:,
                             text: 'Autofahrt',
                             position: 1
  end

  let!(:another_invoice_expense) do
    create :invoice_expense, invoice:,
                             text: 'Eine andere Autofahrt',
                             position: 2
  end

  let!(:expense) do
    create :expense, :default_associations, amount: 200,
                                            date: 1.day.ago,
                                            invoice_effort_id: invoice_expense.id
  end

  let!(:another_expense) do
    create :expense, :default_associations, amount: 300,
                                            date: 10.day.ago,
                                            invoice_effort_id: another_invoice_expense.id
  end

  before do
    create :invoice_expense, invoice:, position: 3

    sign_in invoice.employee
  end

  it 'Group Invoice Expenses', js: true do
    visit invoice_wizard_expenses_path(invoice)

    find(:css, "#effort_ids_[value='#{invoice_expense.id}']").set(true)
    find(:css, "#effort_ids_[value='#{another_invoice_expense.id}']").set(true)

    click_button 'Nebenkosten zusammenführen'

    aggregate_failures 'new invoice expense' do
      within 'td.amount' do
        expect(page).to have_text('500.00')
      end
      expect(Invoices::Expense.count).to eq 2
      expect(Invoices::Expense.first.text).to eq 'Autofahrt'
      expect(Invoices::Expense.first.efforts).to match_array [another_expense, expense]
      expect(Invoices::Expense.first.position).to eq 1
    end
  end
end
