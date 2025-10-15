require 'rails_helper'

describe Hours::CalendarDay do
  let(:calendar_day) do
    described_class.new date:,
                        activities:,
                        absences:,
                        target_hours:,
                        employee:
  end

  let(:date) { Date.parse('2016-12-21') }
  let(:activities) { [] }
  let(:absences) { [] }
  let(:target_hours) { 8 }
  let(:employee) { build :employee }

  around do |example|
    Timecop.freeze '2016-12-24' do
      example.call
    end
  end

  describe '#events' do
    let(:activity_event) { calendar_day.events.find { |e| e.type == :activity } }
    let(:absence_event) { calendar_day.events.find { |e| e.type == :absence } }

    context 'with activities' do
      let(:activities) do
        create_list(:activity, 2, :default_associations, hours: 2)
      end

      describe 'activity_event' do
        it 'sets correct values' do
          expect(activity_event.hours).to eq 4
          expect(activity_event.type).to eq :activity
          expect(activity_event.date).to eq date
          expect(activity_event.target_reached).to be false
          expect(activity_event.employee).to eq employee
        end

        context 'if target is reached' do
          let(:target_hours) { 4 }

          it 'sets target reached' do
            expect(activity_event.target_reached).to be true
          end
        end
      end
    end

    context 'without activities' do
      let(:activities) { [] }

      it 'create activity event with 0 hours' do
        expect(activity_event.hours).to eq 0
      end

      context 'if date is in the future' do
        let(:date) { Date.parse('2016-12-26') }

        it 'does not create a activity event' do
          expect(activity_event).to be_nil
        end
      end

      context 'if date is on the weekend' do
        let(:date) { Date.parse('2016-12-17') }

        it 'does not create a activity event' do
          expect(activity_event).to be_nil
        end
      end

      context 'if employee has worktime model debit_is_actual' do
        let(:employee) { build :employee, worktime_model: :debit_is_actual }

        it 'does not create a activity event' do
          expect(activity_event).to be_nil
        end
      end
    end

    context 'with one-day absences' do
      let(:absences) do
        [
          create(:absence, :default_associations, hours: 2),
        ]
      end

      describe 'absence event' do
        it 'sets correct values' do
          expect(absence_event.date).to eq date
          expect(absence_event.hours).to eq 2
          expect(absence_event.type).to eq :absence
          expect(absence_event.target_reached).to be false
          expect(absence_event.employee).to eq employee
        end

        context 'if target is reached' do
          let(:target_hours) { 2 }

          it 'sets target reached' do
            expect(absence_event.target_reached).to be true
          end
        end
      end
    end

    context 'with spanning absences' do
      let(:absences) do
        [
          create(:absence, :default_associations, from_date: date,
                                                  to_date: date + 1.day,
                                                  hours: 16),
        ]
      end

      it 'sets correct values' do
        expect(absence_event.date).to eq date
        expect(absence_event.hours).to eq 8
      end
    end

    context 'without absences' do
      it 'does not create an absence event' do
        expect(absence_event).to be_nil
      end
    end

    context 'with activities and absences' do
      let(:target_hours) { 4 }

      let(:activities) do
        [
          create(:activity, :default_associations, hours: 2),
        ]
      end

      let(:absences) do
        [
          create(:absence, :default_associations, hours: 2),
        ]
      end

      it 'creates both' do
        expect(activity_event).not_to be_nil
        expect(absence_event).not_to be_nil
      end

      it 'considers both for the target_reached attribute' do
        expect(activity_event.target_reached).to be true
        expect(absence_event.target_reached).to be true
      end
    end

    context 'without activites but absences' do
      let(:activities) { [] }
      let(:absences) do
        [
          create(:absence, :default_associations, hours: 2),
        ]
      end

      it 'creates no activity event' do
        expect(activity_event).to be_nil
      end
    end
  end
end
