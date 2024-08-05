require 'rails_helper'

describe 'Managing Invoice Expenses' do
  let(:employee) { create :employee }
  let(:customer) { create :customer }
  let(:invoice) { create :invoice, employee:, customer:, date: Date.today }
  let(:text) { 'Some work done' }

  before do
    employee.touch
    invoice.touch

    sign_in employee
  end

  it 'List Invoice Expenses' do
    2.times do
      expense = create(:expense, :default_associations, amount: 600)
      create :invoice_expense, invoice:,
                               text:,
                               amount_manually: 400,
                               efforts: [expense]
    end

    create :expense, :default_associations, amount: 150

    visit invoice_wizard_expenses_path(invoice)

    expect(page).to have_text(text)
    expect(page).to have_text('400.00', count: 2) # amount of invoice expenses
    expect(page).to have_text('800.00') # total amount of invoice expenses
    expect(page).to have_text("1'200.00") # actual amount of expenses
    expect(page).to have_text('150.00') # open expenses amount
  end

  it 'Add Invoice Expense' do
    visit invoice_wizard_expenses_path(invoice)

    expect do
      within 'div.actions' do
        click_link 'Nebenkosten erfassen'
      end
    end.to change { Invoices::Expense.count }.from(0).to(1)
  end

  it 'Delete Invoice Expense' do
    invoice_expense = create(:invoice_expense, invoice:)

    visit invoice_wizard_expenses_path(invoice)

    expect do
      click_link "delete-invoice-expense-#{invoice_expense.id}-link"
    end.to change { Invoices::Expense.count }.from(1).to(0)
  end
end
