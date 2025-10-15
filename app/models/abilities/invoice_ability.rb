module Abilities
  class InvoiceAbility < ClassyCancan::BaseAbility
    def setup
      cannot :edit, Invoice
      can :edit, Invoice, &:open?

      cannot :mail, Invoice
      can :mail, Invoice, &:may_mail?

      cannot :complete, Invoice
      can :complete, Invoice, &:may_complete?

      cannot :deliver, Invoice
      can :deliver, Invoice, &:may_deliver?

      cannot :charge, Invoice
      can :charge, Invoice, &:may_charge?

      cannot :reopen, Invoice
      can :reopen, Invoice do |invoice|
        invoice.charged? || invoice.sent?
      end

      cannot :destroy, Invoice
      can :destroy, Invoice, &:open?
    end
  end
end
