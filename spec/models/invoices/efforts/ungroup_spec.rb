require 'rails_helper'

describe Invoices::Efforts::Ungroup do
  subject do
    described_class.new(activity).ungroup_efforts!
  end

  describe '#ungroup_activities!' do
    let(:activity) do
      create :invoice_activity, :default_associations, position: 2
    end

    before do
      create :activity, :default_associations, invoice_effort: activity,
                                               text: 'Huhu',
                                               date: 2.days.ago
      create :activity, :default_associations, invoice_effort: activity,
                                               text: 'Hello',
                                               date: 1.day.ago
    end

    it 'creates an invoice activity for each assigned activity' do
      expect do
        subject
      end.to change(Invoices::Activity, :count).from(1).to 2
    end

    it 'destroy existing activity' do
      expect(activity).to receive(:destroy!)

      subject
    end

    it 'sets correct attributes' do
      subject

      aggregate_failures do
        expect(Invoices::Activity.first.text).to eq 'Huhu'
        expect(Invoices::Activity.second.text).to eq 'Hello'
        expect(Invoices::Activity.first.efforts.first.text).to eq 'Huhu'
        expect(Invoices::Activity.second.efforts.first.text).to eq 'Hello'
      end
    end

    context 'with multiple invoice activities' do
      before do
        create :invoice_activity, :default_associations, position: 1
        create :invoice_activity, :default_associations, position: 3
      end

      it 'inserts the new invoice activities, where the old one was' do
        subject

        expect(Invoices::Activity.find_by(position: 2).text).to eq 'Huhu'
        expect(Invoices::Activity.find_by(position: 3).text).to eq 'Hello'
      end
    end
  end
end
