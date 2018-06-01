module Abilities
  class EmployeeAbility < ClassyCancan::BaseAbility
    def setup
      cannot :destroy, Employee
      can :destroy, Employee do |employee|
        Absence.for_employee(employee.id).none? &&
          Effort.for_employee(employee.id).none? &&
          Invoice.for_employee(employee.id).none?
      end
    end
  end
end
