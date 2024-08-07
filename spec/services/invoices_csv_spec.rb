require 'rails_helper'

describe InvoicesCsv do
  let(:employee) { create :employee, name: 'Irgendein Mitarbeiter' }
  let(:customer) { create :customer, name: 'Irgendein Kunde' }
  let(:invoice) { create :invoice, employee:, customer: }
  let(:invoice_activity) { create :invoice_activity, amount_manually: 1000, invoice: }

  describe '#to_csv' do
    before do
      invoice_activity.touch
    end

    it 'returns CSV with invoices data' do
      expect(described_class.new.to_csv([invoice])).to eq <<~CSV
        ID,Mitarbeiter,Kunde,Rechnungsdatum,Betrag,Status
        #{invoice.id},Irgendein Mitarbeiter,Irgendein Kunde,#{I18n.l(invoice.date)},1'015.00,Offen
      CSV
    end
  end
end
