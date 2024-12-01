require 'rails_helper'

describe Hours::CalendarDayFactory do
  let(:employee) { create :employee }
  let(:customer) { create :customer }

  let(:factory) do
    described_class.new employee:,
                        from: Date.parse('2016-12-01'),
                        to: Date.parse('2016-12-03')
  end

  describe '#build_calendar_days' do
    let(:calendar_days) { factory.build_calendar_days }

    it 'return correct amount of days' do
      expect(calendar_days.count).to eq 3
    end

    context 'with activities' do
      let!(:activity) do
        create :activity, employee:, customer:, date: '2016-12-01'
      end

      it 'assigns activities' do
        expect(calendar_days.first.activities).to eq [activity]
      end

      it 'assigns employee' do
        expect(calendar_days.first.employee).to eq employee
      end
    end

    context 'with multiple absences' do
      let!(:absences) do
        [
          create(:absence, employee:, from_date: '2016-12-01', to_date: '2016-12-01'),
          create(:absence, employee:, from_date: '2016-12-01', to_date: '2016-12-01'),
        ]
      end

      it 'assigns absence' do
        expect(calendar_days.first.absences).to eq absences
      end
    end

    context 'with spanning absence' do
      let!(:absence) do
        create :absence, employee:, from_date: '2016-12-01', to_date: '2016-12-02', hours: 16
      end

      it 'assigns absence to relevant days' do
        expect(calendar_days.first.absences).to eq [absence]
        expect(calendar_days.second.absences).to eq [absence]
        expect(calendar_days.third.absences).to eq []
      end
    end

    context 'with target_hours' do
      before do
        create :target_hours, date: '2016-12-02', hours: 4
      end

      it 'sets target_hours' do
        expect(calendar_days.first.target_hours).to eq 8 # Thursday
        expect(calendar_days.second.target_hours).to eq 4 # Firday with TargetHours
        expect(calendar_days.third.target_hours).to eq 0 # Saturday
      end
    end
  end
end
