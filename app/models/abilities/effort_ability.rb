module Abilities
  class EffortAbility < ClassyCancan::BaseAbility
    def setup
      cannot [:edit, :destroy], ::Effort
      can [:edit, :destroy], ::Effort do |effort|
        effort.state.open? || effort.state.not_chargeable?
      end
    end
  end
end
