require 'rails_helper'

describe 'Managing Invoices' do
  let(:employee) { create :employee }
  let(:customer) { create :customer }

  before do
    sign_in employee
  end

  it 'Create Invoice', js: true do
    visit new_invoice_path

    select2(customer.name, from: 'Kunde', search: true)

    click_button 'Rechnung erfassen'

    expect(page).to have_text 'Rechnung wurde erfasst.'
    expect(page).to have_xpath("//canvas[@id='pdf-canvas' and @height>-1]", wait: 10) # waits for rendered invoice pdf
  end

  it 'Charge nevertheless' do
    invoice = create :invoice, :default_associations, state: :sent

    visit invoice_path(invoice)

    click_link 'Rechnung als bezahlt markieren'

    expect(page).to have_text 'Die Rechnung wurde als bezahlt markiert.'
    expect(invoice.reload.state).to eq 'charged'
  end
end
