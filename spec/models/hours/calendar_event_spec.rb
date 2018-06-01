require 'rails_helper'

describe Hours::CalendarEvent do
  let(:calendar_event) do
    described_class.new date: date,
                        hours: hours,
                        target_reached: target_reached,
                        type: type,
                        employee: employee
  end

  describe '#as_json' do
    let(:date) { Date.parse('2017-01-03') }
    let(:hours) { 8 }
    let(:target_reached) { false }
    let(:type) { :activity }
    let(:employee) { build :employee }

    describe 'color' do
      subject { calendar_event.as_json[:color] }

      context 'if target reached' do
        let(:target_reached) { true }

        it { is_expected.to eq described_class::GREEN }

        context 'if date on weekend' do
          let(:date) { Date.parse('2016-12-24') }

          it { is_expected.to eq described_class::BLUE }
        end
      end

      context 'if target not reached' do
        let(:target_reached) { false }

        it { is_expected.to eq described_class::ORANGE }

        context 'if hours == 0' do
          let(:hours) { 0 }

          it { is_expected.to eq described_class::RED }
        end
      end
    end

    describe 'url' do
      subject { calendar_event.as_json[:url] }

      context 'for activites' do
        let(:type) { :activity }
        let(:expected_url) do
          Rails.application.routes.url_helpers.activities_path(
            { filter: { from: date, to: date, employee: employee } }
          )
        end

        it { is_expected.to eq expected_url }
      end

      context 'for absences' do
        let(:type) { :absence }
        let(:expected_url) do
          Rails.application.routes.url_helpers.absences_path(
            { filter: { from: date, to: date, employee: employee } }
          )
        end

        it { is_expected.to eq expected_url }
      end
    end
  end
end
