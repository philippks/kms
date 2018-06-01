require 'rails_helper'

describe Effort do
  let(:employee) { create :employee, name: 'Irgendein Mitarbeiter' }
  let(:customer) { create :customer, name: 'Irgendein Kunde' }
  let(:not_chargeable_customer) { create :customer, :not_chargeable }

  let!(:activity) do
    create :activity, date: Date.today,
                      employee: employee,
                      customer: customer,
                      state: :open
  end

  let!(:old_activity) do
    create :activity, date: 10.days.ago,
                      employee: employee,
                      customer: not_chargeable_customer
  end

  describe 'text=' do
    it 'strips whitespaces' do
      expect(build(:activity, text: 'something done  ').text).to eq 'something done'
    end
  end

  describe 'before' do
    it 'returns all efforts before given date' do
      expect(described_class.before(Date.yesterday)).to eq [old_activity]
    end

    it 'includes given date' do
      expect(described_class.before(Date.today)).to match_array [old_activity, activity]
    end
  end

  describe 'after' do
    it 'returns all efforts after given date' do
      expect(described_class.after(Date.yesterday)).to eq [activity]
    end

    it 'includes given date' do
      expect(described_class.after(10.days.ago)).to match_array [old_activity, activity]
    end
  end

  describe 'for_customer' do
    subject { described_class.for_customer(customer) }

    before do
      create :activity, :with_associations
    end

    it { is_expected.to eq [activity] }
  end

  describe 'for_employee' do
    subject { described_class.for_employee(employee) }

    before do
      create :activity, :with_associations
    end

    it { is_expected.to match_array [old_activity, activity] }
  end

  describe 'for_state' do
    it 'returns efforts for a state' do
      expect(described_class.for_state(:open)).to eq [activity]
    end
  end

  describe 'for_customer_group' do
    let(:customer_group) { create :customer_group, name: 'Irgendeine Kundengruppe' }
    let(:customer_with_customer_group) { create :customer, customer_group: customer_group }
    let!(:other_activity) do
      create :activity, employee: employee, customer: customer_with_customer_group
    end

    it 'returns efforts for a customer_group' do
      expect(described_class.for_customer_group(customer_group).to_a).to eq [other_activity]
    end
  end

  describe 'between' do
    let(:event_older_activity) do
      create :activity, employee: employee,
                        customer: customer,
                        date: 20.days.ago
    end

    it 'returns efforts between parameters' do
      expect(described_class.between(from: 15.days.ago, to: 5.days.ago)).to eq [old_activity]
    end
  end

  describe 'before_save' do
    let(:invoice) { create :invoice, customer: customer, employee: employee }

    it 'sets default state to open' do
      expect(activity.state.to_sym).to eq :open
    end

    it 'updates state on save' do
      expect do
        activity.customer = not_chargeable_customer
        activity.save
      end.to change { activity.reload.state.to_sym }.from(:open).to(:not_chargeable)
    end

    context 'with not chargeable customer group' do
      it 'sets state to not_chargeable' do
        expect(old_activity.state.to_sym).to eq :not_chargeable
      end
    end

    context 'when assigned to invoice_effort' do
      it 'sets state to charged' do
        expect do
          create :invoice_activity, invoice: invoice, efforts: [activity]
        end.to change { activity.state.to_sym }.from(:open).to :charged
      end
    end

    context 'if invoice effort was destroyed' do
      let!(:invoice_activity) { create :invoice_activity, invoice: invoice, efforts: [activity] }

      it 'sets state to open' do
        expect do
          invoice_activity.destroy!
        end.to change { activity.reload.state.to_sym }.from(:charged).to :open
      end
    end
  end
end
