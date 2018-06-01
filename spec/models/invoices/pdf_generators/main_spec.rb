require 'rails_helper'

describe Invoices::PDFGenerators::Main do
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

  let(:format) { :compact }

  let(:invoice_params) do
    {
      format: format,
      date: '2015-03-22',
      vat_rate: 0.015,
      customer: customer,
      employee: employee,
      created_by_initials: 'ek',
    }
  end
  let(:invoice) { create :invoice, invoice_params }

  describe '#generate_odt' do
    let(:odf_report) { instance_double 'ODFReport::Report' }
    let!(:invoice_activities) do
      Array.new(2) do
        create :invoice_activity, invoice: invoice,
                                  hours_manually: 8,
                                  hourly_rate_manually: 150,
                                  text: 'viele Stunden Arbeit'
      end
    end
    let!(:invoice_expense) { create :invoice_expense, invoice: invoice, amount_manually: 100 }

    subject { pdf.generate_odt }

    let(:report_double) { double }
    let(:activity_row_double) { double }

    before do
      allow(ODFReport::Report).to(
        receive(:new).with(
          "#{Rails.root}/config/templates/invoice_#{format}.odt"
        ).and_yield(report_double).and_return(report_double)
      )

      allow(report_double).to receive(:add_field)
      allow(report_double).to receive(:add_section)
      allow(report_double).to receive(:remove_section)
      allow(report_double).to receive(:generate)
    end

    it 'add necessary fields' do
      expect(report_double).to receive(:add_field).with(
        :confidential_title, customer_params[:confidential_title]
      )
      expect(report_double).to receive(:add_field).with(
        :address, customer_params[:address]
      )
      expect(report_double).to receive(:add_field).with(
        :date, '22. März 2015'
      )
      expect(report_double).to receive(:add_field).with(
        :created_by_initials, 'ek'
      )
      expect(report_double).to receive(:add_field).with(
        :title, 'im März 2015'
      )
      expect(report_double).to receive(:add_field).with(
        :vat_number, 'CHE-013.131.123'
      )
      expect(report_double).to receive(:add_field).with(
        :vat_rate, 1.5
      )
      expect(report_double).to receive(:add_field).with(
        :iban, 'CH90 1337 1337 1337 1337 8'
      )
      expect(report_double).to receive(:add_field).with(
        :swift, '134134 1234134 123134'
      )
      expect(report_double).to receive(:add_field).with(
        :activities_amount, "2'400.00"
      )
      expect(report_double).to receive(:add_field).with(
        :expenses_amount, "100.00"
      )
      expect(report_double).to receive(:add_field).with(
        :sub_total, "2'500.00"
      )
      expect(report_double).to receive(:add_field).with(
        :vat_amount, '37.50'
      )
      expect(report_double).to receive(:add_field).with(
        :total, "2'537.50"
      )
      expect(report_double).to receive(:add_field).with(
        :possible_wir_amount, ''
      )

      subject
    end

    it 'adds a row for each activity' do
      aggregate_failures do
        expect(report_double).to receive(:add_section) do |key, value|
          expect(key).to eq :activity_row
          expect(value.map(&:id)).to eq invoice_activities.map(&:id)
        end.and_yield activity_row_double

        expect(activity_row_double).to receive(:add_field).with(
          :text, :text
        ).once

        expect(activity_row_double).to receive(:add_field).with(
          :hours, :hours
        ).once

        expect(activity_row_double).to receive(:add_field).with(
          :rate, :hourly_rate_as_int
        ).once

        expect(activity_row_double).to receive(:add_field).with(
          :amount, :humanized_amount
        ).once
      end

      subject
    end

    context 'with hidden activities' do
      before do
        create :invoice_activity, invoice: invoice, visible: false
      end

      it 'only adds visible activities' do
        expect(report_double).to receive(:add_section) do |key, value|
          expect(key).to eq :activity_row
          expect(value.map(&:id)).to eq invoice_activities.map(&:id)
        end

        subject
      end
    end

    describe 'swift and confidential handling' do
      let(:invoice_params) do
        super().merge(
          confidential: false,
          display_swift: false
        )
      end

      it 'removes sections' do
        expect(report_double).to(
          receive(:remove_section).with(:swift)
        )

        expect(report_double).to(
          receive(:remove_section).with(:confidential)
        )

        expect(report_double).to(
          receive(:remove_section).with(:confidential_activities_placeholder)
        )

        subject
      end

      context 'if flags are set' do
        let(:invoice_params) do
          super().merge(
            confidential: true,
            display_swift: true
          )
        end

        it 'does not removes sections' do
          expect(report_double).not_to(
            receive(:remove_section).with(:swift)
          )

          expect(report_double).not_to(
            receive(:remove_section).with(:confidential)
          )

          subject
        end
      end
    end

    context 'with manually set title' do
      let(:invoice_params) do
        super().merge(
          title: 'eigener Title für die Rechnung'
        )
      end

      it 'uses manually set title' do
        expect(report_double).to receive(:add_field).with(
          :title, 'eigener Title für die Rechnung'
        )

        subject
      end
    end

    context 'with detailed invoice' do
      let(:format) { :detailed }

      it 'uses correct template' do
        expect(ODFReport::Report).to(
          receive(:new).with(
            "#{Rails.root}/config/templates/invoice_detailed.odt"
          )
        ).and_return report_double

        subject
      end
    end

    context 'with possible wir amount' do
      let(:invoice_params) do
        super().merge(
          possible_wir_amount: 1000
        )
      end

      it 'add necessary fields' do
        expect(report_double).to receive(:add_field).with(
          :possible_wir_amount, "(CHF 1'000 WIR-Zahlung möglich)"
        )

        subject
      end
    end

    context 'with detailed invoice and confidential activities' do
      let(:invoice_params) do
        super().merge(confidential: true)
      end

      let(:format) { :detailed }

      before do
        create :invoice_activity, invoice: invoice,
                                  confidential: true,
                                  hours_manually: 2,
                                  hourly_rate_manually: 150

      end

      it 'add necessary fields' do
        expect(report_double).to receive(:add_field).with(:confidential_hours, 2.0)
        expect(report_double).to receive(:add_field).with(:confidential_rate, '150')
        expect(report_double).to receive(:add_field).with(:confidential_amount, '300.00')

        subject
      end

    end
  end
end
