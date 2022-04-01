require 'rails_helper'

describe Activities::Report do
  let(:report) { described_class.new from_date: from_date, to_date: to_date }
  let(:from_date) { Date.parse '2015-02-01' }
  let(:to_date) { Date.parse '2015-02-28' }

  let(:employee) { create :employee }
  let(:other_employee) { create :employee, workload: 50 }
  let(:customer) { create :customer }
  let(:other_customer) { create :customer }

  before do
    create :activity, employee: employee, customer: customer, date: from_date + 1.day, hours: 1, hourly_rate: 500
    create :activity, employee: employee, customer: other_customer, date: from_date + 1.day, hours: 1

    create :absence, employee: other_employee
  end

  describe '#employees' do
    it 'returns relevant employees' do
      expect(report.employees).to eq [employee, other_employee]
    end
  end

  describe '#customers_by_customer_group' do
    let!(:customer_group) { create :customer_group }
    let!(:customer_with_group) { create :customer, customer_group: customer_group }

    subject { report.customers_by_customer_group }

    before do
      create :activity, employee: employee, customer: customer_with_group, date: from_date + 1.day
    end

    it 'groups customers correctly' do
      expect(subject).to eq({
        nil => [customer, other_customer].sort_by(&:name),
        customer_group => [customer_with_group]
      })
    end
  end

  describe '#effort_value_for' do
    it 'works for activities' do
      expect(report.effort_value_for(nil, customer, :activities)).to eq Money.from_amount(500)
    end

    it 'considers default expenses' do
      expect(report.effort_value_for(nil, customer, :expenses)).to eq Money.from_amount(25)
    end
  end

  describe '#invoice_value_for' do
    before do
      [:open, :sent, :charged].each do |state|
        create :invoice, customer: customer,
                         employee: employee,
                         date: from_date,
                         state: state,
                         activities_amount_manually: 500
      end
    end

    it 'considers sent and charged invoices' do
      expect(report.invoice_value_for(nil, customer, :charged)).to eq Money.from_amount(1000)
    end
  end

  describe '#total_hours_for' do
    before do
      create :absence, employee: employee, hours: 4, from_date: from_date, to_date: from_date
    end

    it 'sums effort and absence hours' do
      expect(report.total_hours_for(employee)).to eq 6
    end
  end

  describe '#target_hours_for' do
    before do
      create :target_hours, date: Date.parse('2015-02-03'), hours: 4
    end

    it 'returns correct amount of target hours' do
      expect(report.target_hours_for(employee)).to eq 156
      expect(report.target_hours_for(other_employee)).to eq 78
    end
  end
end
