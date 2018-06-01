require 'rails_helper'

describe Invoices::Expense do
  describe '.default_amount_for' do
    let(:activities_amount) { 800 }

    subject(:default_amount) do
      described_class.default_amount_for(activities_amount: Money.from_amount(activities_amount))
    end

    context 'with floating amount' do
      let(:activities_amount) { 802.5 }

      it 'rounds to the nearest multiple of 5' do
        expect(default_amount).to eq Money.from_amount 40
      end
    end

    context 'with floating amount to round up' do
      let(:activities_amount) { 860.5 }

      it 'rounds to the nearest multiple of 5' do
        expect(default_amount).to eq Money.from_amount 45
      end
    end

    context 'without activities amount' do
      let(:activities_amount) { 0 }

      it 'returns 0' do
        expect(default_amount).to eq Money.from_amount 0
      end
    end

    context 'with low activities amount' do
      let(:activities_amount) { 50 }

      it 'returns minimum 5' do
        expect(default_amount).to eq Money.from_amount 5
      end
    end

    context 'with high activities amount' do
      let(:activities_amount) { 10_000 }

      it 'returns maximum 125' do
        expect(default_amount).to eq Money.from_amount 125
      end
    end
  end
end
