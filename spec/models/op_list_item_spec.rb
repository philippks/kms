require 'rails_helper'

describe OpListItem do
  let(:employee_1) { create :employee }
  let(:employee_2) { create :employee }
  let(:customer_1) { create :customer }
  let(:customer_2) { create :customer }

  let!(:activity_1) do
    create :activity, customer: customer_1, employee: employee_1
  end
  let!(:activity_2) do
    create :activity,
           customer: customer_1, employee: employee_2, date: 2.weeks.ago
  end
  let!(:activity_3) do
    create :activity, customer: customer_2, employee: employee_2
  end

  describe '.build_for' do
    subject(:op_list_items) do
      described_class.build_for(
        employee_id: employee_id, until_date: until_date
      )
    end

    let(:employee_id) { nil }
    let(:until_date) { Date.current }

    it 'returns one item for each customer' do
      expect(op_list_items.length).to eq 2

      expect(op_list_items.first.customer).to eq customer_1
      expect(op_list_items.first.activities).to eq [activity_1, activity_2]

      expect(op_list_items.second.customer).to eq customer_2
      expect(op_list_items.second.activities).to eq [activity_3]
    end

    context 'filtered by employee' do
      let(:employee_id) { employee_1.id }

      it 'only returns item where employee is part of' do
        expect(op_list_items.length).to eq 1
        expect(op_list_items.first.customer).to eq customer_1
        expect(op_list_items.first.activities).to eq [activity_1, activity_2]
      end
    end

    context 'filtered by date' do
      let(:until_date) { 3.weeks.ago }

      it 'only returns items until the date' do
        expect(op_list_items.length).to eq 2
        expect(op_list_items.first.customer).to eq customer_1
        expect(op_list_items.first.activities).to eq [activity_1]
      end
    end
  end

  describe '#range_string' do
    subject { described_class.build_for(employee_id: nil).first.range_string }

    context 'when dates spans multiple months' do
      let(:activity_1) do
        create :activity,
               customer: customer_1, employee: employee_1, date: '2017-01-01'
      end
      let(:activity_2) do
        create :activity,
               customer: customer_1, employee: employee_2, date: '2016-01-01'
      end

      it { is_expected.to eq 'Januar 2016 bis Januar 2017' }
    end

    context 'when dates are in one month' do
      let(:activity_1) do
        create :activity,
               customer: customer_1, employee: employee_1, date: '2017-01-01'
      end
      let(:activity_2) do
        create :activity,
               customer: customer_1, employee: employee_2, date: '2017-01-03'
      end

      it { is_expected.to eq 'Januar 2017' }
    end
  end

  describe '#employees' do
    subject { described_class.build_for(employee_id: nil).first.employees }

    it { is_expected.to eq [employee_1, employee_2] }
  end

  describe '#overdue?' do
    subject do
      described_class.build_for(employee_id: nil).first.overdue?
    end

    describe 'when amount of activities before given date >= given amount' do
      let(:activity_1) do
        create :activity,
               customer: customer_1,
               employee: employee_1,
               date: 4.months.ago,
               hours: 1,
               hourly_rate: 500
      end
      let(:activity_2) do
        create :activity,
               customer: customer_1,
               employee: employee_2,
               date: 4.months.ago,
               hours: 1,
               hourly_rate: 700
      end

      it { is_expected.to be true }

      describe 'when newer activity exists' do
        let(:activity_3) do
          create :activity,
                 customer: customer_1,
                 employee: employee_2,
                 date: 1.months.ago,
                 hours: 4,
                 hourly_rate: 500
        end

        it { is_expected.to be false }
      end
    end

    describe 'when amount of activities before given date < given amount' do
      it { is_expected.to be false }
    end
  end
end
