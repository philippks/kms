require 'rails_helper'

describe Abilities::Invoices::PaymentAbility do
  subject { Ability.new(employee) }

  let(:employee) { invoice.employee }
  let(:invoice) { create :invoice, :default_associations, state: state }
  let(:payment) { build :payment, invoice: invoice }

  context 'open invoice' do
    let(:state) { 'open' }

    it { is_expected.to_not be_able_to :manage, payment }
  end

  context 'sent invoice' do
    let(:state) { 'sent' }

    it { is_expected.to be_able_to :manage, payment }
  end

  context 'charged invoice' do
    let(:state) { 'charged' }

    it { is_expected.to_not be_able_to :manage, payment }
    it { is_expected.to     be_able_to :read, payment }
  end
end
