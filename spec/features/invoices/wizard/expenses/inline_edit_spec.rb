require 'rails_helper'

describe 'Inline-Edit Expense Text' do
  let(:invoice) { create :invoice, :default_associations }
  let(:invoice_expense) { create :invoice_expense, text: 'Lala', invoice: }

  before do
    invoice_expense.touch

    sign_in invoice.employee
  end

  it 'Edit Text with Inline-Edit', js: true do
    visit invoice_wizard_expenses_path(invoice)

    page.find('span', text: 'Lala').click
    within(:css, 'div.editable-input') do
      find(:css, 'textarea').set 'Juhui'
    end
    page.find('div.editable-buttons').find('button').click

    expect(page).to have_text('Juhui')
    expect(invoice_expense.reload.text).to eq 'Juhui'
  end
end
