class TargetHours < ActiveRecord::Base
  DEFAULT_TARGET_HOURS = 8

  validates :date, :hours, presence: true
  validates_inclusion_of :hours, in: [0, 4, 6, 8]

  # increments hours from 0 to 4 or by 2
  def increment_hours
    return self.hours = 4 if hours.zero?

    self.hours += 2
  end

  # deletes the instance if hours >= 8
  def save_or_delete!
    return delete if hours >= DEFAULT_TARGET_HOURS

    save!
  end

  # need to override the json view to return what full_calendar is expecting.
  # http://arshaw.com/fullcalendar/docs/event_data/Event_Object/
  def as_json(_options = {})
    {
      id:,
      title: "#{hours} Stunden",
      start: date.iso8601,
      end: date.iso8601,
      allDay: true,
      recurring: false,
      color: hours < DEFAULT_TARGET_HOURS ? 'blue' : 'green',
    }
  end

  def self.between(from:, to:)
    TargetHours.where('date >= ? AND date <= ?', from, to)
  end

  def self.hours_per_date(from:, to:)
    target_hours_per_date = between(from:, to:).group_by(&:date)

    (from..to).each do |date|
      target_hours_per_date[date] = if target_hours_per_date[date].blank?
                                      default_target_hours_for(date)
                                    else
                                      target_hours_per_date[date].first.hours
                                    end
    end

    target_hours_per_date
  end

  def self.hours_between(from:, to:)
    hours_per_date(from:, to:).values.sum(0)
  end

  def self.hours_between_for_employee(from:, to:, employee:)
    hours_between(from:, to:) * employee.workload_in_percent
  end

  def self.default_target_hours_for(date)
    if date.saturday? || date.sunday?
      0
    else
      DEFAULT_TARGET_HOURS
    end
  end
end
