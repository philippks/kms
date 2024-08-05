require 'rails_helper'

describe InvoicePresenter do
  let(:invoice) { create :invoice, :default_associations }
  let(:presenter) { described_class.new(invoice) }

  describe 'with confidential activities' do
    before do
      create_list :invoice_activity, 2, invoice:,
                                        confidential: true,
                                        hours_manually: 2,
                                        hourly_rate_manually: 150
    end

    describe 'confidential_hours' do
      subject { presenter.confidential_hours }

      it { is_expected.to eq 4 }
    end

    describe 'confidential_hourly_rate' do
      subject { presenter.confidential_hourly_rate }

      it { is_expected.to eq '150' }

      describe 'with various hourly rates' do
        before do
          create :invoice_activity, invoice:,
                                    confidential: true,
                                    hourly_rate_manually: 250
        end

        it { is_expected.to eq 'Div.' }
      end
    end

    describe 'confidential_amount' do
      subject { presenter.confidential_amount }

      it { is_expected.to eq '600.00' }
    end
  end
end
