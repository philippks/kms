require 'rails_helper'

describe Invoices::Title do
  let(:invoice) do
    create :invoice, :with_associations, date: invoice_date
  end
  let(:invoice_date) { '2015-06-01' }
  let(:invoice_activity) { create :invoice_activity, invoice: }

  describe '#to_s' do
    subject { described_class.new(invoice).to_s }

    context 'when only one date exists' do
      let(:invoice_date) { '2015-01-19' }

      before do
        create :activity, :default_associations,
               date: '2015-01-19',
               invoice_effort_id: invoice_activity.id
      end

      it { is_expected.to eq 'vom 19. Januar 2015' }
    end

    context 'when dates are in one month' do
      let(:invoice_date) { '2015-01-24' }

      before do
        create :activity, :default_associations,
               date: '2015-01-19',
               invoice_effort_id: invoice_activity.id

        create :activity, :default_associations,
               date: '2015-01-23',
               invoice_effort_id: invoice_activity.id
      end

      it { is_expected.to eq 'vom 19. bis 24. Januar 2015' }
    end

    context 'when dates are spanning multiple months' do
      let(:invoice_date) { '2015-03-19' }

      before do
        create :activity, :default_associations,
               date: '2015-01-19',
               invoice_effort_id: invoice_activity.id
      end

      it { is_expected.to eq 'vom 19. Januar bis 19. März 2015' }
    end

    context 'when dates are spanning multiple years' do
      let(:invoice_date) { '2016-03-19' }

      before do
        create :activity, :default_associations,
               date: '2015-01-19',
               invoice_effort_id: invoice_activity.id
      end

      it { is_expected.to eq 'vom 19. Januar 2015 bis 19. März 2016' }
    end

    context 'when there are no activities' do
      it 'takes date of invoice' do
        expect(subject).to eq 'im Juni 2015'
      end
    end
  end
end
