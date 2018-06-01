module Abilities
  class CustomerGroupAbility < ClassyCancan::BaseAbility
    def setup
      cannot :destroy, CustomerGroup
      can :destroy, CustomerGroup do |customer_group|
        Customer.for_customer_group(customer_group.id).none?
      end
    end
  end
end
