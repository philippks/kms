require 'rails_helper'

describe Abilities::EmployeeAbility do
  subject { Ability.new(employee) }

  let(:employee) { create :employee }

  it { is_expected.to be_able_to :destroy, employee }

  context 'with absences' do
    before do
      create :absence, employee:
    end

    it { is_expected.not_to be_able_to :destroy, employee }
  end

  context 'with efforts' do
    before do
      create :activity, employee:, customer: create(:customer)
    end

    it { is_expected.not_to be_able_to :destroy, employee }
  end

  context 'with invoices' do
    before do
      create :invoice, employee:, customer: create(:customer)
    end

    it { is_expected.not_to be_able_to :destroy, employee }
  end
end
