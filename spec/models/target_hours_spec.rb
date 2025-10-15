require 'rails_helper'

describe TargetHours do
  it 'increments hours correctly' do
    tg = create :target_hours, hours: 0

    expect { tg.increment_hours }.to change { tg.hours }.to 4
    expect { tg.increment_hours }.to change { tg.hours }.to 6
    expect { tg.increment_hours }.to change { tg.hours }.to 8
  end

  it 'deletes the instance if hours equals 8' do
    tg = create :target_hours, hours: 8

    expect { tg.save_or_delete! }.to change(described_class, :count).to 0
  end

  it 'renders the instance correctly as json for the calendar' do
    target_hours = build :target_hours, id: 1337, date: '2015-01-19', hours: 0

    expect(target_hours.as_json).to eq(
      {
        id: 1337,
        title: '0 Stunden',
        start: '2015-01-19',
        end: '2015-01-19',
        allDay: true,
        recurring: false,
        color: 'blue',
      }
    )
  end

  describe '.between' do
    subject do
      described_class.between from: Date.parse('2016-12-19'), to: Date.parse('2016-12-20')
    end

    let!(:target_hours) { create :target_hours, date: '2016-12-19', hours: 4 }

    before do
      create :target_hours, date: '2016-12-18'
      create :target_hours, date: '2016-12-21'
    end

    it { is_expected.to eq [target_hours] }
  end

  describe 'hours_per_date' do
    subject do
      described_class.hours_per_date from: Date.parse('2016-12-01'),
                                     to: Date.parse('2016-12-31')
    end

    before do
      create :target_hours, date: '2016-12-02', hours: 4
    end

    it 'considers created target hours' do
      expect(subject[Date.parse('2016-12-02')]).to eq 4
    end

    it 'returns 8 hours for day without manually set target hours' do
      expect(subject[Date.parse('2016-12-05')]).to eq 8
    end
  end

  describe '.hours_between' do
    subject do
      described_class.hours_between(from:, to:)
    end
    let(:from) { Date.parse('2016-12-19') } # monday
    let(:to) { Date.parse('2016-12-20') } # tuesday

    before do
      create :target_hours, date: '2016-12-19', hours: 4
    end

    it 'sums default target hours and created target hours' do
      expect(subject).to eq 12
    end

    context 'over weekend' do
      let(:from) { Date.parse '2016-12-18' } # sunday

      it 'do not add target hours for the weekend' do
        expect(subject).to eq 12
      end
    end
  end
end
