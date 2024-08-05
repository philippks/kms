require 'rails_helper'

describe 'New Invoice PDF' do
  let(:employee) { create :employee }
  let(:customer) { create :customer, confidential_title: 'Lölimann' }
  let(:invoice_attributes) do
    {
      customer:,
      employee:,
      vat_rate: 0.08,
      date: '2017-10-01',
    }
  end
  let!(:invoice) { create :invoice, invoice_attributes }

  before do
    sign_in employee
  end

  it 'shows visible activity texts' do
    create :invoice_activity, invoice:, text: 'Däumchen drehen'

    visit new_invoice_pdf_path(invoice, format: :pdf, html: true)

    expect(page).to have_text 'Däumchen drehen'
  end

  it 'does not show hidden activity texts' do
    create :invoice_activity, invoice:, visible: false, text: 'Däumchen drehen'

    visit new_invoice_pdf_path(invoice, format: :pdf, html: true)

    expect(page).not_to have_text 'Däumchen drehen'
  end

  it 'shows invoice title' do
    visit new_invoice_pdf_path(invoice, format: :pdf, html: true)

    expect(page).not_to have_text 'Weitere Leistungen vom 19. Januar'
  end

  it 'shows correct amounts' do
    create :invoice_activity, invoice:, amount_manually: 500
    create :invoice_activity, invoice:, amount_manually: 200
    create :invoice_expense, invoice:, amount_manually: 100

    visit new_invoice_pdf_path(invoice, format: :pdf, html: true)

    expect(page).to have_text '700.00' # activities
    expect(page).to have_text '100.00' # expenses
    expect(page).to have_text '800.00' # subtotal
    expect(page).to have_text '64.00' # vat_rate
    expect(page).to have_text '864.00' # total amount
  end

  context 'when invoice has possible wir amount' do
    let(:invoice_attributes) do
      super().merge possible_wir_amount: 2000
    end

    it 'shows possible wir amount on invoice' do
      visit new_invoice_pdf_path(invoice, format: :pdf, html: true)

      expect(page).to have_text "(CHF 2'000 WIR-Zahlung möglich)"
    end
  end

  context 'when invoice is confidential' do
    let(:invoice_attributes) do
      super().merge confidential: true
    end

    it 'shows confidential title of customer' do
      visit new_invoice_pdf_path(invoice, format: :pdf, html: true)

      expect(page).to have_text 'Persönlich / Vertraulich'
      expect(page).to have_text 'Lölimann'
    end

    context 'when invoice has confidential invoices' do
      let(:activity) do
        create :activity, customer:, employee:, date: '2017-01-19'
      end

      before do
        create :invoice_activity, invoice:,
                                  confidential: true,
                                  text: 'Gugus',
                                  efforts: [activity]
      end

      it 'shows confidential supplement' do
        visit new_invoice_pdf_path(invoice, format: :pdf, html: true)

        expect(page).to have_text 'Vertrauliches Beiblatt'
        expect(page).to have_text 'Weitere Leistungen vom 19. Januar bis 1. Oktober 2017'
        expect(page).to have_text 'Hombrechtikon, 1. Oktober 2017' # invoice date
      end
    end
  end

  context 'when activities should break the page' do
    it 'adds pagebreak class to table row' do
      create :invoice_activity, invoice:, pagebreak: true

      visit new_invoice_pdf_path(invoice, format: :pdf, html: true)

      expect(page).to have_css 'div.pagebreak'
    end
  end
end
