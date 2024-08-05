require 'rails_helper'

describe 'Managing Payments' do
  let!(:invoice) do
    create :invoice, :with_associations, activities_amount_manually: 400, state: :sent
  end
  let!(:payment) { create :payment, invoice:, amount: 200 }

  before do
    sign_in invoice.employee
  end

  it 'List payments' do
    create :payment, invoice:, amount: 50

    visit invoice_payments_path(invoice)

    expect(page).to have_text('200.00')
    expect(page).to have_text('250.00')
  end

  it 'Create new payment' do
    visit new_invoice_payment_path(invoice)

    fill_in 'Betrag', with: '50'
    click_button 'Zahlung erfassen'

    expect(page).to have_text('Zahlung wurde erfasst.')
  end

  it 'Create new payment with total amount' do
    visit new_invoice_payment_path(invoice)

    fill_in 'Betrag', with: invoice.reload.open_amount
    click_button 'Zahlung erfassen'

    expect(page).to have_text('Die Rechnung wurde als bezahlt markiert.')
  end

  it 'Create new payment and mark invoice as charged anyway' do
    visit new_invoice_payment_path(invoice)

    fill_in 'Betrag', with: '50'
    check 'Rechnung in jedem Fall als bezahlt markieren'
    click_button 'Zahlung erfassen'

    expect(page).to have_text('Die Rechnung wurde als bezahlt markiert.')
  end

  it 'Update a payment' do
    visit edit_invoice_payment_path(invoice, payment)

    fill_in 'Betrag', with: '100'

    click_button 'Zahlung aktualisieren'

    expect(page).to have_current_path invoice_payments_path(invoice)
    expect(page).to have_text('100.00')
  end

  it 'Destroy a payment' do
    visit edit_invoice_payment_path(invoice, payment)

    click_link 'Löschen'

    expect(page).to have_content 'Zahlung wurde gelöscht.'
  end
end
