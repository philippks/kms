module Activities
  class Report
    class EffortsCube
      AMOUNT_KEYS = %i[activities expenses turnover].freeze
      KEYS = (AMOUNT_KEYS + [:hours]).freeze

      def initialize(efforts)
        @efforts = efforts
      end

      def value_for(*keys)
        check_key! keys.last

        values.dig(*keys) || nil_value_for(keys.last)
      end

      private

      def check_key!(key)
        raise "invalid data key: #{key}" if KEYS.exclude? key
      end

      def nil_value_for(key)
        AMOUNT_KEYS.include?(key) ? Money.from_amount(0) : 0
      end

      def values
        @values ||= @efforts.inject({}) do |values, effort|
          values.deep_merge!(values_hash_for(effort)) do |_key, old_value, new_value|
            (old_value || 0) + (new_value || 0)
          end
        end
      end

      # Returns following hash for the given effort
      # {
      #   total: {
      #     values...
      #   },
      #
      #   nil => {
      #     customer_1: {
      #       employee_1: {
      #         values...
      #       }
      #
      #       employee_2: {
      #         values...
      #       }
      #
      #       values...
      #     }
      #
      #     employee_1: {
      #       ...
      #     }
      #
      #     employee_2: {
      #       ...
      #     }
      #
      #     values...
      #   }
      #
      #   customer_group_1 => {
      #     ...
      #   }
      # }
      def values_hash_for(effort)
        activities = (effort.amount if effort.is_a?(Activity)) || Money.from_amount(0)
        expenses = (effort.amount if effort.is_a?(Expense)) || Money.from_amount(0)

        values = {
          hours: effort.hours,
          activities:,
          expenses:,
          turnover: activities + expenses,
        }

        {
          total: values,
          effort.employee => values,
          effort.customer.customer_group => {
            effort.customer => {
              effort.employee => values,
            }.merge(values),
            effort.employee => values,
          }.merge(values),
        }
      end
    end
  end
end
