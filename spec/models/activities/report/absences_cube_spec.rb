require 'rails_helper'

describe Activities::Report::AbsencesCube do
  let(:employee) { create :employee }
  let(:other_employee) { create :employee }
  let(:date) { Date.parse '2016-12-20' }

  let(:absences) do
    [
      build(:absence, employee:,
                      from_date: date,
                      to_date: date,
                      hours: 4,
                      reason: :doctor),

      build(:absence, employee:,
                      from_date: (date - 1.day),
                      to_date: date,
                      hours: 16,
                      reason: :holidays),

      build(:absence, employee: other_employee,
                      from_date: date,
                      to_date: date,
                      hours: 4,
                      reason: :holidays),
    ]
  end

  let(:cube) do
    described_class.new absences, from: date.beginning_of_month,
                                  to: date.end_of_month
  end

  describe '#value_for' do
    it 'works for employee' do
      expect(cube.value_for(employee, :hours)).to eq 20
    end

    it 'works for employee -> reason' do
      expect(cube.value_for(employee, 'doctor', :hours)).to eq 4
    end

    context 'with absence out of range' do
      let(:absences) do
        [
          build(:absence, employee:,
                          from_date: (date.beginning_of_month - 2.day),
                          to_date: (date.beginning_of_month + 2.day),
                          hours: 32,
                          reason: :doctor),
        ]
      end

      it 'only counts target hours within range' do
        expect(cube.value_for(employee, :hours)).to eq 16
      end
    end
  end
end
