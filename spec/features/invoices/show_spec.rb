require 'rails_helper'

feature 'View Invoice' do
  let(:employee) { create :employee }
  let(:customer) { create :customer }

  before do
    sign_in employee
  end

  context 'when invoice state is open' do
    let!(:invoice) do
      create :invoice, customer: customer, employee: employee, state: :open
    end

    context 'when a invoice hint is present' do
      let(:customer) { create :customer, invoice_hint: 'Unbedingt vertikal falten' }

      scenario 'the hint is shown' do
        visit invoice_path(invoice)

        expect(page).to have_text 'Unbedingt vertikal falten'
      end
    end

    context 'when open efforts before the invoice date exists' do
      before do
        create :activity, state: :open, employee: employee, customer: customer, date: (invoice.date - 1.week)
      end

      it 'shows a warning' do
        visit invoice_path(invoice)

        expect(page).to have_text 'Achtung, diese Rechnung umfasst nicht alle offenen Leistungen bis zum Rechnungsdatum.'
      end
    end
  end
end
