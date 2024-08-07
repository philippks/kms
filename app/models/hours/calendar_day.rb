class Hours
  class CalendarDay
    attr_reader :date, :activities, :absences, :target_hours, :employee

    def initialize(date:, activities:, absences:, target_hours:, employee:)
      @date         = date
      @activities   = activities
      @absences     = absences
      @target_hours = target_hours
      @employee     = employee
    end

    def events
      [
        (activity_event if show_activity_event?),
        (absence_event if show_absence_event?),
      ].compact
    end

    private

    def activity_event
      CalendarEvent.new date:,
                        hours: activities_hours,
                        type: :activity,
                        target_reached: total_hours >= target_hours,
                        employee:
    end

    def show_activity_event?
      activities.any? ||
        (employee.worktime_model.target_hours? &&
         (date.past? && date.on_weekday?) && absences.none?)
    end

    def absence_event
      CalendarEvent.new date:,
                        hours: absences_hours,
                        type: :absence,
                        target_reached: total_hours >= target_hours,
                        employee:
    end

    def show_absence_event?
      absences_hours.positive?
    end

    def activities_hours
      activities.map(&:hours).sum(0).to_f
    end

    def absences_hours
      absences.map do |absence|
        absence.absent_target_hours(from: date, to: date).to_f
      end.sum(0)
    end

    def total_hours
      activities_hours + absences_hours
    end
  end
end
