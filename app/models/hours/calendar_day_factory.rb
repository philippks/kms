class Hours
  class CalendarDayFactory
    attr_reader :employee, :from, :to

    def initialize(employee:, from:, to:)
      @employee = employee
      @from = from
      @to = to
    end

    def build_calendar_days
      (from..to).map do |date|
        CalendarDay.new date:,
                        activities: activities_for(date),
                        absences: absences_for(date),
                        target_hours: target_hours_for(date),
                        employee:
      end
    end

    private

    def activities_for(date)
      activities_by_date[date] || []
    end

    def absences_for(date)
      absences_by_date[date] || []
    end

    def activities_by_date
      @activities ||= Activity.for_employee(employee)
                              .between(from:, to:)
                              .group_by(&:date)
    end

    def absences_by_date
      @absences ||= Absence.for_employee(employee)
                           .between(from:, to:)
                           .inject({}) do |hash, absence|
        hash.merge(absence.per_date_hash) do |_key, lhs, rhs|
          lhs.concat rhs
        end
      end
    end

    def target_hours_for(date)
      target_hours_per_date[date]
    end

    def target_hours_per_date
      @target_hours_per_date ||= TargetHours.hours_per_date(from:, to:)
    end
  end
end
