require 'rails_helper'

describe Invoices::Validations do
  let(:invoice) { build :invoice, :with_associations, invoice_params }

  subject { invoice }

  context 'detailed invoice format' do
    let(:invoice_params) do
      {
        format: :detailed
      }
    end

    describe 'with manually set activities_amount' do
      let(:invoice_params) do
        super().merge(activities_amount_manually: 42)
      end

      it 'is invalid' do
        expect(subject).not_to be_valid
        expect(subject.errors.first.attribute).to eq :format
      end
    end

    describe 'with hidden activities' do
      before do
        subject.activities = [build(:invoice_activity, invoice: subject, visible: false)]
      end

      it 'is invalid' do
        expect(subject).not_to be_valid
        expect(subject.errors.first.attribute).to eq :format
      end
    end

    describe 'with conflicting activities' do
      let(:invoice_activity) do
        build :invoice_activity, invoice: subject, efforts: [
          build(:activity, hourly_rate: 1, employee: subject.employee, customer: subject.customer),
          build(:activity, hourly_rate: 2, employee: subject.employee, customer: subject.customer),
        ]
      end

      before do
        subject.activities = [invoice_activity]
      end

      it 'is invalid' do
        expect(subject).not_to be_valid
        expect(subject.errors.first.attribute).to eq :format
      end
    end
  end
end
