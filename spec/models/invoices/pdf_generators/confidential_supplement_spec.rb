require 'rails_helper'

describe Invoices::PDFGenerators::ConfidentialSupplement do
  let(:pdf) { described_class.new(invoice) }

  let(:employee) { create :employee }

  let(:customer_params) do
    {
      name: 'Hans Meier',
      address: 'Meiersstrasse 10\n3791 Hanshausen',
      confidential_title: 'Hansi'
    }
  end
  let(:customer) { create :customer, customer_params }

  let(:invoice_params) do
    {
      date: '2015-03-22',
      customer: customer,
      employee: employee
    }
  end
  let(:invoice) { create :invoice, invoice_params }

  describe '#generate_odt' do
    let(:odf_report) { instance_double 'ODFReport::Report' }
    let!(:invoice_activities) do
      create_list :invoice_activity, 2, invoice: invoice,
                                        confidential: true,
                                        text: 'viele Stunden Arbeit'
    end

    subject { pdf.generate_odt }

    let(:report_double) { double }
    let(:activity_row_double) { double }

    before do
      allow(ODFReport::Report).to(
        receive(:new).with(
          "#{Rails.root}/config/templates/invoice_compact_confidential_supplement.odt"
        ).and_yield(report_double).and_return(report_double)
      )

      allow(report_double).to receive(:add_field)
      allow(report_double).to receive(:generate)
      allow(report_double).to receive(:add_section)
    end

    it 'add necessary fields' do
      expect(report_double).to receive(:add_field).with(
        :date, '22. März 2015'
      )
      expect(report_double).to receive(:add_field).with(
        :title, 'im März 2015'
      )
      expect(report_double).to receive(:add_field).with(
        :customer, 'Hans Meier'
      )

      subject
    end

    it 'adds a row for each activity' do
      aggregate_failures do
        expect(report_double).to receive(:add_section) do |key, value|
          expect(key).to eq :activity_row
          expect(value.map(&:id)).to eq invoice_activities.map(&:id)
        end.and_yield activity_row_double

        expect(activity_row_double).to receive(:add_field).with(:text, :text).once
        expect(activity_row_double).to receive(:add_field).with(:hours, :hours).once
        expect(activity_row_double).to receive(:add_field).with(:rate, :hourly_rate_as_int).once
        expect(activity_row_double).to receive(:add_field).with(:amount, :humanized_amount).once
      end

      subject
    end

    context 'with non confidential activities' do
      before do
        create :invoice_activity, invoice: invoice, confidential: false
      end

      it 'ignores them' do
        expect(report_double).to receive(:add_section) do |key, value|
          expect(key).to eq :activity_row
          expect(value.map(&:id)).to eq invoice_activities.map(&:id)
        end

        subject
      end
    end
  end
end
