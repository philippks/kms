require 'rails_helper'

describe 'Select expenses' do
  let(:invoice) { create :invoice, :default_associations }
  let(:invoice_expense) { create :invoice_expense, invoice: }
  let(:expense) { create(:expense, :default_associations) }

  before do
    invoice_expense.touch
    expense.touch

    sign_in invoice.employee
  end

  it 'Select expenses for Invoice expense' do
    visit edit_invoice_expense_path(invoice, invoice_expense)

    page.check('expense[effort_ids][]')
    click_button 'Rechnungs-Nebenkosten aktualisieren'

    expect(invoice_expense.reload.efforts).to eq [expense]
  end

  it 'De-Select expense for Invoice expense' do
    invoice_expense.update efforts: [expense]
    visit edit_invoice_expense_path(invoice, invoice_expense)

    page.uncheck('expense[effort_ids][]')
    click_button 'Rechnungs-Nebenkosten aktualisieren'

    expect(invoice_expense.reload.efforts).to eq []
  end
end
