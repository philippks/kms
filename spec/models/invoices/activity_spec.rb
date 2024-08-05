require 'rails_helper'

describe Invoices::Activity do
  let(:employee) { create :employee }
  let(:customer) { create :customer, name: 'Mr Right' }

  let(:invoice) { create :invoice, customer:, employee: }
  let(:invoice_activity) { create :invoice_activity, invoice: }

  let(:activity) { create(:activity, customer:, employee:) }

  describe '#destroy' do
    it 'nullify assigned activities foreign keys' do
      invoice_activity.update effort_ids: [activity.id]
      invoice_activity.destroy

      expect(activity.reload.invoice_effort_id).to eq nil
    end
  end

  describe '#hourly_rate' do
    subject(:hourly_rate) { invoice_activity.hourly_rate }

    context 'without assigned activities' do
      it 'returns 0' do
        expect(hourly_rate).to eq 0
      end
    end

    context 'with assigned activities' do
      let(:some_activity) do
        create :activity, hourly_rate: first_hourly_rate, customer:, employee:
      end

      let(:another_activity) do
        create :activity, hourly_rate: second_hourly_rate, customer:, employee:
      end

      before do
        invoice_activity.update efforts: [some_activity, another_activity]
      end

      context 'with the same hourly rate' do
        let(:first_hourly_rate) { 150 }
        let(:second_hourly_rate) { 150 }

        it 'returns this hourly rate' do
          expect(hourly_rate).to eq Money.from_amount 150
        end
      end

      context 'with different hourly rates' do
        let(:first_hourly_rate) { 150 }
        let(:second_hourly_rate) { 170 }

        it 'returns nil' do
          expect(hourly_rate).to eq nil
        end

        context 'and manually set hourly rate' do
          before do
            invoice_activity.update hourly_rate_manually: 200
          end

          it 'returns manually set hourly rate' do
            expect(hourly_rate).to eq Money.from_amount 200
          end
        end
      end

      context 'with manually set hourly rate' do
        let(:first_hourly_rate) { 150 }
        let(:second_hourly_rate) { 150 }

        before do
          invoice_activity.update hourly_rate_manually: 200
        end

        it 'returns manually set hourly rate' do
          expect(hourly_rate).to eq Money.from_amount 200
        end
      end
    end
  end

  describe '#hours' do
    subject(:hours) { invoice_activity.hours }

    context 'without assigned activities' do
      it 'returns 0' do
        expect(hours).to eq 0
      end
    end

    context 'with assigned activities' do
      let(:some_activity) do
        create :activity, hours: 3, customer:, employee:
      end

      let(:another_activity) do
        create :activity, hours: 1.4, customer:, employee:
      end

      before do
        invoice_activity.update efforts: [some_activity, another_activity]
      end

      it 'returns sum of hours of assigned acitivites' do
        expect(hours).to eq 4.4
      end

      context 'with manually set hours' do
        before do
          invoice_activity.update hours_manually: 3
        end

        it 'returns manually set hours' do
          expect(hours).to eq 3
        end
      end
    end
  end

  describe '#actual_amount' do
    context 'with assigned activities' do
      before do
        invoice_activity.efforts << [
          create(:activity, :default_associations, hours: 2, hourly_rate: 150),
          create(:activity, :default_associations, hours: 1.5, hourly_rate: 150),
        ]
      end

      it 'returns sum of all assigned activities' do
        expect(invoice_activity.actual_amount).to eq Money.from_amount 525
      end
    end
  end

  describe '#amount' do
    subject(:amount) { invoice_activity.amount }

    context 'without assigned activities' do
      it 'returns 0' do
        expect(amount).to eq 0
      end
    end

    context 'with assigned activities' do
      before do
        invoice_activity.efforts << [
          create(:activity, :default_associations, hours: 2, hourly_rate: 150),
          create(:activity, :default_associations, hours: 1.5, hourly_rate: 150),
        ]
      end

      it 'returns sum of all assigned activities' do
        expect(amount).to eq Money.from_amount 525
      end

      context 'with manually set hourly rate' do
        before do
          invoice_activity.update hourly_rate_manually: 200
        end

        it 'calculates sum with manually set hourly rate' do
          expect(amount).to eq Money.from_amount 700
        end
      end

      context 'with manually set hours' do
        before do
          invoice_activity.update hours_manually: 5
        end

        it 'calculates sum with manually set hourly rate' do
          expect(amount).to eq Money.from_amount 750
        end

        context 'and confliciting hourly_rates' do
          before do
            invoice_activity.efforts << [
              create(:activity, :default_associations, hours: 2, hourly_rate: 200),
            ]
          end

          it 'ignores manually set hours and returns sum of all assigned activities' do
            expect(amount).to eq Money.from_amount 925
          end
        end
      end
    end
  end
end
