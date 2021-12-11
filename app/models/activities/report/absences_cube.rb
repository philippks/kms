module Activities
  class Report
    class AbsencesCube
      KEYS = [:hours].freeze

      def initialize(absences, from:, to:)
        @absences = absences
        @from = from
        @to = to
      end

      def value_for(*keys)
        raise "invalid key #{keys.last}" if KEYS.exclude? keys.last

        values.dig(*keys) || 0
      end

      private

      def values
        @values ||= @absences.inject({}) do |values, absence|
          values.deep_merge!(values_hash_for(absence)) do |_key, old_value, new_value|
            (old_value || 0) + (new_value || 0)
          end
        end
      end

      # Returns following hash for the given absence
      # {
      #   employee_1: {
      #     hours: 10
      #
      #     reason_1: {
      #       hours: 5,
      #     }
      #     reason_2: {
      #       hours: 5,
      #     }
      #   },
      #   employee_2: {
      #     ...
      #   },
      # }
      def values_hash_for(absence)
        hours = absence.absent_target_hours(from: @from, to: @to)

        {
          absence.employee => {
            absence.reason => {
              hours: hours * (absence.employee.workload_in_percent)
            },

            hours: hours * (absence.employee.workload_in_percent)
          }
        }
      end
    end
  end
end
