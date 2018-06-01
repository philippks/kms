require 'rails_helper'

describe Hours::Subjects do
  describe 'customers_for' do
    let(:query) { 'Fri' }
    let!(:customer_1) { create :customer, name: 'Ruedi' }
    let!(:customer_2) { create :customer, name: 'Fritzli' }

    subject(:subjects) { described_class.customers_for(query) }

    it 'returns filtered by query' do
      expect(subjects).to eq [customer_2]
    end

    it 'does not return inactive customers' do
      customer_2.update!(deactivated: true)

      expect(subjects).to eq []
    end
  end

  describe 'absence_reasons_for' do
    let(:query) { 'Fer' }

    subject(:subjects) { described_class.absence_reasons_for(query) }

    it 'returns absence reasons filtered by query' do
      expect(subjects).to eq ['holidays']
    end
  end

  describe 'last_customers' do
    let(:employee) { create :employee }
    let(:other_employee) { create :employee }

    subject(:subjects) { described_class.last_customers_for(employee) }

    let(:customer_1) { create :customer }
    let(:customer_2) { create :customer }
    let(:customer_3) { create :customer }

    before do
      create :activity, employee: employee, customer: customer_1, date: '2017-05-01'
      create :activity, employee: employee, customer: customer_1, date: '2017-05-02'
      create :activity, employee: other_employee, customer: customer_2
      create :activity, employee: employee, customer: customer_3, date: '2017-06-03'
    end

    it 'returns last distinct customers employee has create activity for' do
      expect(subjects).to eq [customer_3, customer_1]
    end

    context 'with many customers' do
      before do
        5.times do
          customer = create :customer
          create :activity, employee: employee, customer: customer, date: '2017-04-01'
        end
      end

      it 'returns only 5' do
        expect(subjects.size).to eq 5
      end
    end
  end
end
