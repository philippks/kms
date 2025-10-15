require 'rails_helper'

describe Invoices::Effort do
  it { is_expected.to validate_presence_of :invoice }

  describe '#amount' do
    subject { invoice_activity.amount }

    let(:efforts) do
      create_list(:activity, 2, hours: 1, hourly_rate: 150)
    end

    let(:invoice_activity) do
      create :invoice_activity, efforts:
    end

    it { eq 300 }

    context 'when amount_is set manually' do
      let(:invoice_activity) do
        create :invoice_activity, efforts:,
                                  amount_manually: 720
      end

      it { eq 720 }
    end
  end

  describe '#after_create' do
    let!(:effort) { create :activity, :default_associations }

    it 'updates state of effort' do
      expect do
        create :invoice_activity, :default_associations, efforts: [effort]
      end.to change { effort.reload.state.to_sym }.from(:open).to(:charged)
    end
  end

  describe '#before_destroy' do
    let(:invoice_activity) { create :invoice_activity, :with_associations }
    let!(:activity) { create :activity, :default_associations, invoice_effort: invoice_activity }

    it 'nullifies assigned efforts' do
      expect do
        invoice_activity.destroy!
      end.to change { activity.reload.invoice_effort }.from(invoice_activity).to nil
    end

    it 'calls save callbacks of efforts' do
      expect do
        invoice_activity.destroy!
      end.to change { activity.reload.state.to_sym }.from(:charged).to :open
    end
  end

  describe '#assignable_efforts' do
    subject(:selection) { invoice_activity.assignable_efforts }

    let(:customer) { create :customer }
    let(:employee) { create :employee }
    let(:invoice) { create :invoice, customer:, employee: }
    let(:invoice_activity) { create :invoice_activity, invoice: }
    let(:activity) { create(:activity, customer:, employee:) }

    it 'returns activities by customer' do
      other_customer = create :customer, name: 'Mr Wrong'
      create(:activity, customer: other_customer, employee:)

      expect(selection).to eq [activity]
    end

    it 'returns already assigned activities' do
      invoice_activity.update effort_ids: [activity.id]

      expect(selection).to eq [activity]
    end

    it 'does not return activities assigned to an other invoice activity' do
      other_activity = create(:activity, customer:, employee:)
      create :invoice_activity, invoice:, efforts: [other_activity]

      expect(selection).to eq [activity]
    end

    it 'does not return efforts with other types' do
      create(:expense, customer:, employee:)

      expect(selection).to eq [activity]
    end
  end
end
