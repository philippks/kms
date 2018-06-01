require 'rails_helper'

describe Activity do
  describe 'amount' do
    let(:activity) do
      create :activity, :with_associations, hourly_rate: 150, hours: hours
    end

    context 'integer hours' do
      let(:hours) { 2 }

      it 'returns correct amount' do
        expect(activity.amount).to eq Money.from_amount 300
      end
    end

    context 'floating hours' do
      let(:hours) { 1.21 }

      it 'returns correct amount' do
        expect(activity.amount).to eq Money.from_amount 181.5
      end
    end
  end

  describe 'open_amount_for' do
    let(:customer) { create :customer }

    before do
      customer.touch

      create :activity, :default_associations, hourly_rate: 150, hours: 1

      invoice_effort = create :invoice_activity, :default_associations
      create :activity, :default_associations, hourly_rate: 150, hours: 1,
                                               invoice_effort: invoice_effort
    end

    it 'returns amount of activities for a customer,
        which are not yet assigned to an invoice' do
      expect(described_class.open_amount_for(customer)).to eq Money.from_amount 150
    end
  end

  describe 'update_amount' do
    context 'with not chargeable customer' do
      let(:customer) { create :customer, :not_chargeable }
      let(:employee) { create :employee }

      let(:activity) do
        create :activity, customer: customer, employee: employee, hourly_rate: 150, hours: 2
      end

      it 'updates amount to 0' do
        expect(activity.amount).to eq 0
      end
    end
  end
end
