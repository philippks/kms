require 'rails_helper'

describe Abilities::CustomerGroupAbility do
  subject { Ability.new(employee) }

  let(:employee) { create :employee }
  let(:customer_group) { create :customer_group }

  it { is_expected.to be_able_to :destroy, customer_group }

  context 'with customer' do
    before do
      create :customer, customer_group: customer_group
    end

    it { is_expected.not_to be_able_to :destroy, customer_group }
  end
end
