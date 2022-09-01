require 'rails_helper'

describe Absence do
  describe 'validations' do
    context 'with absence spanning mutliple days' do
      it 'is invalid when to-date after from-date' do
        absence = build :absence, from_date: 2.days.from_now, to_date: 1.day.ago

        expect(absence.valid?).to be false
      end

      it 'is invalid when hours not nil' do
        absence = build :absence, from_date: 2.day.ago, to_date: 1.day.ago, hours: 3

        expect(absence.valid?).to be false
      end
    end
  end

  describe '#for_reason' do
    subject { described_class.for_reason :doctor }

    let(:absence) do
      create :absence, :default_associations, reason: :doctor
    end

    before do
      create :absence, :default_associations, reason: :holidays
    end

    it { is_expected.to eq [absence] }
  end

  describe '#absent_target_hours' do
    subject { absence.absent_target_hours }

    context 'absence on one day' do
      let(:absence) do
        build :absence, hours: 2
      end

      it { is_expected.to eq 2 }
    end

    context 'absence spanning multiple days' do
      let(:absence) do
        build :absence, from_date: '2016-12-12', to_date: '2016-12-13'
      end

      it 'returns correct absent target hours' do
        expect(subject).to eq 16
      end

      context 'overlapping target hours' do
        before do
          create :target_hours, date: '2016-12-12', hours: 4
        end

        it 'considers target_hours' do
          expect(subject).to eq 12
        end
      end
    end


    describe 'limiting date range' do
      let(:range) { { from: Date.parse('2016-12-01'), to: Date.parse('2016-12-05') } }

      let(:absence) do
        build :absence, from_date: '2016-11-30', to_date: '2016-12-06'
      end

      subject do
        absence.absent_target_hours **range
      end

      it 'only returns value between limited date range' do
        expect(subject).to eq 24
      end

      context 'it range is bigger than actual date' do
        let(:range) { { from: Date.parse('2016-11-01'), to: Date.parse('2016-12-31') } }

        it 'ignores range' do
          expect(subject).to eq 40
        end
      end
    end
  end

  describe 'between' do
    subject { described_class.between(**range) }

    let!(:absence) do
      create :absence, hours: nil, from_date: '2016-11-30', to_date: '2016-12-06'
    end

    context 'with not covering range' do
      let(:range) { { from: Date.parse('2016-11-01'), to: Date.parse('2016-11-02') } }

      it { is_expected.to eq [] }
    end

    context 'with covering range' do
      let(:range) { { from: Date.parse('2016-11-01'), to: Date.parse('2016-12-31') } }

      it { is_expected.to eq [absence] }
    end

    context 'with overlapping to_date' do
      let(:range) { { from: Date.parse('2016-12-05'), to: Date.parse('2016-12-31') } }

      it { is_expected.to eq [absence] }
    end

    context 'with overlapping from_date' do
      let(:range) { { from: Date.parse('2016-11-01'), to: Date.parse('2016-12-01') } }

      it { is_expected.to eq [absence] }
    end
  end
end
