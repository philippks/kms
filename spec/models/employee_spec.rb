require 'rails_helper'

describe Employee do
  let(:customer) { create :customer }
  let(:employee) { create :employee }

  describe '.active' do
    let!(:active_employee) { create :employee }
    let!(:deactivated_employee) { create :employee, deactivated: true }

    it 'only returns active employees' do
      expect(Employee.active).to eq [active_employee]
    end
  end

  describe 'deactivate' do
    let(:employee) { create :employee, deactivated: true }

    context 'with open activities' do
      before do
        create :activity, employee:, customer:, state: :open
      end

      it 'is not possible to deactivate' do
        expect(employee).to be_invalid
        expect(employee.errors).to have_key :deactivated
      end
    end

    context 'with open invoice' do
      before do
        create :invoice, employee:, customer:, state: :open
      end

      it 'is not possible to deactivate' do
        expect(employee).to be_invalid
        expect(employee.errors).to have_key :deactivated
      end
    end

    context 'with sent invoice' do
      before do
        create :invoice, employee:, customer:, state: :sent
      end

      it 'is not possible to deactivate' do
        expect(employee).to be_invalid
        expect(employee.errors).to have_key :deactivated
      end
    end
  end

  describe 'activity methods' do
    before do
      create :activity, employee:, customer:, date: Date.current, hours: 2
      create :activity, employee:, customer:, date: Date.current, hours: 3
      create :activity, employee:, customer:, date: 1.day.ago, hours: 3
      create :activity, employee: (create :employee), customer:, hours: 3
    end

    around do |example|
      Timecop.freeze '2017-01-03' do
        example.call
      end
    end

    describe '#activity_hours_today' do
      subject { employee.activity_hours_today }

      it { is_expected.to eq 5 }
    end

    describe '#target_hours_reached_in_percent' do
      subject { employee.target_hours_reached_in_percent }

      it { is_expected.to eq 62.5 }
    end
  end

  describe 'valid_password?' do
    subject { employee.valid_password? password }

    let(:employee) { create :employee, password: 'password', password_confirmation: 'password' }
    let(:password) { 'password' }

    it { is_expected.to eq true }

    context 'with invalid password' do
      let(:password) { 'invalid password' }

      it { is_expected.to eq false }
    end
  end
end
