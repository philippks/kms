require 'rails_helper'

describe Activities::Report::InvoicesCube do
  let(:employee) { create :employee }
  let(:customer_group) { create :customer_group }
  let(:customer) { create :customer, customer_group: customer_group }
  let(:other_customer) { create :customer, customer_group: customer_group }
  let(:date) { Date.parse '2016-12-20' }
  let(:cube) { described_class.new invoices }

  let(:invoices) do
    [
      build(:invoice, employee: employee,
                      customer: customer,
                      date: date,
                      activities_amount_manually: 500),
      build(:invoice, employee: employee,
                      customer: other_customer,
                      date: date,
                      activities_amount_manually: 500),
    ]
  end

  describe '#value_for' do
    it 'works for customer' do
      expect(cube.value_for(customer_group, customer, :charged)).to eq Money.from_amount 500
    end

    it 'works for customer_groups' do
      expect(cube.value_for(customer_group, :charged)).to eq Money.from_amount 1000
    end
  end
end
