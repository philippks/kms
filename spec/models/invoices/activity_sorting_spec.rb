require 'rails_helper'

describe Invoices::Activity do
  subject { invoice.reload.activities.map(&:id) }

  let(:invoice) do
    create :invoice, :default_associations
  end

  before do
    create :invoice_activity, invoice:, id: 10
    create :invoice_activity, invoice:, id: 11
    create :invoice_activity, invoice:, confidential: true, id: 101
    create :invoice_activity, invoice:, confidential: true, id: 102
  end

  describe 'default order' do
    it { is_expected.to eq [10, 11, 101, 102] }
  end

  describe 'order second non confidential higher' do
    before do
      described_class.find(11).move_higher
    end

    it { is_expected.to eq [11, 10, 101, 102] }
  end

  describe 'order top confidential higher' do
    it 'change nothing' do
      expect(described_class.find(101).move_higher).to be_nil
      expect(subject).to eq [10, 11, 101, 102]
    end
  end

  describe 'make another activity confidential' do
    before do
      described_class.find(11).update confidential: true
    end

    it 'moves new confidential activity to bottom of confidentials' do
      expect(subject).to eq [10, 101, 102, 11]
    end
  end

  describe 'make another activity non-confidential' do
    before do
      described_class.find(102).update confidential: false
    end

    it 'moves new non-confidential activity to bottom of non-confidentials' do
      expect(subject).to eq [10, 11, 102, 101]
    end
  end
end
