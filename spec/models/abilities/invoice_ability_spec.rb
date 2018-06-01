require 'rails_helper'

describe Abilities::InvoiceAbility do
  subject { Ability.new(employee) }

  let(:employee) { invoice.employee }
  let(:invoice) { create :invoice, :default_associations, state: state }

  context 'open invoice' do
    let(:state) { 'open' }

    it { is_expected.to     be_able_to :destroy, invoice }
    it { is_expected.to     be_able_to :edit, invoice }
    it { is_expected.not_to be_able_to :complete, invoice }
    it { is_expected.to     be_able_to :deliver, invoice }
    it { is_expected.not_to be_able_to :charge, invoice }
    it { is_expected.not_to be_able_to :reopen, invoice }
  end

  context 'sent invoice' do
    let(:state) { :sent }

    it { is_expected.not_to be_able_to :destroy, invoice }
    it { is_expected.not_to be_able_to :edit, invoice }
    it { is_expected.not_to be_able_to :complete, invoice }
    it { is_expected.not_to be_able_to :deliver, invoice }
    it { is_expected.to     be_able_to :charge, invoice }
    it { is_expected.to     be_able_to :reopen, invoice }
  end

  context 'charged invoice' do
    let(:state) { :charged }

    it { is_expected.not_to be_able_to :destroy, invoice }
    it { is_expected.not_to be_able_to :edit, invoice }
    it { is_expected.not_to be_able_to :complete, invoice }
    it { is_expected.not_to be_able_to :deliver, invoice }
    it { is_expected.not_to be_able_to :charge, invoice }
    it { is_expected.to     be_able_to :reopen, invoice }
  end
end
