module Abilities
  class CustomerAbility < ClassyCancan::BaseAbility
    def setup
      cannot :destroy, Customer
      can :destroy, Customer do |customer|
        Effort.for_customer(customer.id).none? &&
          Invoice.for_customer(customer.id).none?
      end
    end
  end
end
