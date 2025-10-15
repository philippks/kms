require 'rails_helper'

describe CustomersCsv do
  describe 'csv' do
    subject(:csv) { described_class.new(customers).csv }

    let(:customer_group) { build :customer_group, name: 'Kundengruppe' }

    let(:customers) do
      [
        build(:customer, name: 'Kunde 1', invoice_hint: 'Per Mail'),
        build(:customer, name: 'Kunde 2', customer_group:),
      ]
    end

    it 'contains header row' do
      expect(csv.lines.first).to eq(
        "\"name\",\"confidential_title\",\"address\",\"email_address\",\"customer_group_name\",\"invoice_hint\"\n"
      )
    end

    it 'contains the customers attributes' do
      expected = <<~EXPECTED
        "Kunde 1","Hansi","Meiersstrasse 10\\n3791 Hanshausen","hans@hausen.ch","","Per Mail"
        "Kunde 2","Hansi","Meiersstrasse 10\\n3791 Hanshausen","hans@hausen.ch","Kundengruppe",""
      EXPECTED

      expect(csv.lines[1..].join).to eq expected
    end
  end
end
