require 'rails_helper'

describe 'Complete Wizard Page' do
  let(:employee) { create :employee }
  let(:invoice) { create :invoice, :default_associations }

  before do
    sign_in invoice.employee

    invoice.touch
  end

  it 'Complete the invoice' do
    visit invoice_wizard_complete_path(invoice)

    fill_in 'WIR Zahlung möglich', with: 100
    check 'SWIFT einblenden'
    fill_in 'Rechnungstitel', with: 'Einfallsreicher Titel'
    select 'Detailliert', from: 'Rechnungsformat'

    click_button 'Speichern und Schliessen'

    invoice.reload
    aggregate_failures do
      expect(invoice.possible_wir_amount).to eq Money.from_amount 100
      expect(invoice.display_swift).to be true
      expect(invoice.title).to eq 'Einfallsreicher Titel'
      expect(invoice.format.to_sym).to eq :detailed
    end
  end

  it 'Overwrite Activities Amount', js: true do
    visit invoice_wizard_complete_path(invoice)

    within('.invoice_activities_amount_manually') do
      within('.form-control') do
        find(:css, 'span').click
      end
    end

    within('.editable-input') do
      find(:css, 'input', wait: 5).set '1337'
    end

    within('.editable-buttons') do
      find('.editable-submit').click
    end

    expect(page).to have_css 'span', text: "1'337.00", wait: 5
    expect(invoice.reload.activities_amount_manually).to eq Money.from_amount 1337
  end
end
