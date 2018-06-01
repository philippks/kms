module Abilities
  module Invoices
    class PaymentAbility < ClassyCancan::BaseAbility
      def setup
        cannot :manage, ::Invoices::Payment
        can :read, ::Invoices::Payment, invoice: { state: 'charged' }
        can :manage, ::Invoices::Payment, invoice: { state: 'sent' }
      end
    end
  end
end
