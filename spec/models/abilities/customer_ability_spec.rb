require 'rails_helper'

describe Abilities::CustomerAbility do
  subject { Ability.new(employee) }

  let(:employee) { create :employee }
  let(:customer) { create :customer }

  it { is_expected.to be_able_to :destroy, customer }

  context 'with efforts' do
    before do
      create :activity, employee:, customer:
    end

    it { is_expected.not_to be_able_to :destroy, customer }
  end

  context 'with invoices' do
    before do
      create :invoice, employee:, customer:
    end

    it { is_expected.not_to be_able_to :destroy, customer }
  end
end
