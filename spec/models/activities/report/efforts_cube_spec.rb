require 'rails_helper'

describe Activities::Report::EffortsCube do
  let(:employee) { create :employee }
  let(:other_employee) { create :employee }
  let(:customer) { create :customer, customer_group: customer_group }
  let(:other_customer) { create :customer }
  let(:customer_group) { create :customer_group }

  let(:constellations) do
    [
      {
        customer: customer,
        employee: employee,
      },
      {
        customer: customer,
        employee: employee,
      },
      {
        customer: customer,
        employee: other_employee,
      },
      {
        customer: other_customer,
        employee: employee,
      },
      {
        customer: other_customer,
        employee: other_employee,
      },
    ]
  end

  let(:efforts) do
    constellations.map do |constellation|
      [
        build(:activity, constellation.merge(hours: 1, hourly_rate: 100)),
        build(:expense, constellation.merge(amount: 50))
      ]
    end.flatten
  end

  describe '#value_for' do
    let(:cube) { described_class.new(efforts) }

    def check_amounts_for(*keys, activities:, expenses:, turnover: activities + expenses, hours:)
      expect(cube.value_for(*(keys + [:activities]))).to eq Money.from_amount activities
      expect(cube.value_for(*(keys + [:expenses]))).to eq Money.from_amount expenses
      expect(cube.value_for(*(keys + [:turnover]))).to eq Money.from_amount turnover
      expect(cube.value_for(*(keys + [:hours]))).to eq hours
    end

    it 'works for total amount' do
      check_amounts_for(:total, activities: 500, expenses: 250, hours: 5)
    end

    it 'works for customer_group' do
      check_amounts_for(customer_group, activities: 300, expenses: 150, hours: 3)
    end

    it 'works for customer_group -> customer' do
      check_amounts_for(customer_group, customer, activities: 300, expenses: 150, hours: 3)
    end

    it 'works for customer_group -> customer -> employee' do
      check_amounts_for(customer_group, customer, employee, activities: 200, expenses: 100, hours: 2)
    end

    it 'works for customer_group -> employee' do
      check_amounts_for(customer_group, employee, activities: 200, expenses: 100, hours: 2)
    end

    it 'works for employee' do
      check_amounts_for(employee, activities: 300, expenses: 150, hours: 3)
    end
  end
end
