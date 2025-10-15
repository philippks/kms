require 'rails_helper'

describe Invoices::Payment do
  let(:invoice) do
    build :invoice, :with_associations, state: :sent,
                                        activities_amount_manually: 100
  end
  let(:payment) { build :payment, invoice:, amount: }

  describe 'validations' do
    subject { payment }

    context 'amount is greater than open invoice amount' do
      let(:amount) { 200 }

      it { is_expected.not_to be_valid }
    end
  end
end
