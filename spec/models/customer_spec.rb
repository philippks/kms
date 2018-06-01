require 'rails_helper'

describe Customer do
  subject { build :customer, customer_group: build(:customer_group) }

  describe 'validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :address }

    context 'not chargeable customer' do
      subject { described_class.new customer_group: customer_group }

      let(:customer_group) { build :customer_group, not_chargeable: true }

      it { is_expected.not_to validate_presence_of :address }
    end

    context 'invoice delivery by post' do
      subject { build :customer, invoice_delivery: :post }

      it { is_expected.not_to validate_presence_of :email_address }
    end

    context 'invoice delivery by email' do
      subject { build :customer, invoice_delivery: :email }

      it { is_expected.to validate_presence_of :email_address }
    end
  end
end
