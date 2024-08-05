require 'rails_helper'

describe Abilities::EffortAbility do
  subject { Ability.new(employee) }

  let(:employee) { create :employee }
  let(:customer) { create :customer }
  let(:effort) do
    create :activity, employee:,
                      customer:
  end

  it { is_expected.to be_able_to :manage, effort }

  context 'if not_chargeable' do
    let(:customer_group) do
      create :customer_group, not_chargeable: true, customer: [customer]
    end

    it { is_expected.to be_able_to :manage, effort }
  end

  context 'if charged' do
    let(:invoice) do
      create :invoice, customer:, employee:
    end

    before do
      create :invoice_activity, invoice:, efforts: [effort]
    end

    it { is_expected.to be_able_to :show, effort }
    it { is_expected.not_to be_able_to :edit, effort }
    it { is_expected.not_to be_able_to :destroy, effort }
  end
end
