require 'rails_helper'

describe ActivitiesCsv do
  let(:employee) { create :employee, name: 'Irgendein Mitarbeiter' }
  let(:customer) { create :customer, name: 'Irgendein Kunde' }
  let(:activity) { create :activity, employee:, customer:, hourly_rate: 150, hours: 10 }

  describe '#to_csv' do
    it 'returns CSV with activities data' do
      expect(described_class.new.to_csv([activity])).to eq <<~CSV
        ID,Mitarbeiter,Kunde,Datum,Anzahl Stunden,Stundensatz,Betrag,Rechnungstext,Notiz,Status,Leistungskategorie
        #{activity.id},Irgendein Mitarbeiter,Irgendein Kunde,18.02.2015,10.0,150.00,1'500.00,Steuererklärung ausgefüllt,"",Offen,Buchhaltung
      CSV
    end
  end
end
