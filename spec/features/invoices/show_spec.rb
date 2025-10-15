require 'rails_helper'

describe 'View Invoice' do
  let(:employee) { create :employee }
  let(:customer) { create :customer }

  before do
    sign_in employee
  end

  context 'when invoice state is open' do
    let!(:invoice) do
      create :invoice, customer:, employee:, state: :open
    end

    context 'when a invoice hint is present' do
      let(:customer) { create :customer, invoice_hint: 'Unbedingt vertikal falten' }

      it 'the hint is shown' do
        visit invoice_path(invoice)

        expect(page).to have_text 'Unbedingt vertikal falten'
      end
    end

    context 'when open efforts before the invoice date exists' do
      before do
        create :activity, state: :open, employee:, customer:, date: (invoice.date - 1.week)
      end

      it 'shows a warning' do
        visit invoice_path(invoice)

        expect(page).to have_text 'Achtung, diese Rechnung umfasst nicht alle offenen Leistungen bis zum Rechnungsdatum'
      end
    end
  end
end
