class Ability
  include CanCan::Ability

  def initialize(user)
    cannot :manage, :all

    can :manage, :all if user.present?

    Abilities::EmployeeAbility.setup(self, user)
    Abilities::CustomerAbility.setup(self, user)
    Abilities::CustomerGroupAbility.setup(self, user)
    Abilities::EffortAbility.setup(self, user)
    Abilities::InvoiceAbility.setup(self, user)
    Abilities::Invoices::PaymentAbility.setup(self, user)
  end
end
