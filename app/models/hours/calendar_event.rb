class Hours
  class CalendarEvent
    GREEN        = '#468847'.freeze
    GREEN_LIGHT  = '#D6E9C6'.freeze
    ORANGE       = '#C09853'.freeze
    ORANGE_LIGHT = '#FCF8E3'.freeze
    BLUE         = '#3A87AD'.freeze
    RED          = '#B94A48'.freeze

    attr_reader :date, :hours, :type, :target_reached, :employee

    def initialize(date:, hours:, type:, target_reached:, employee:)
      @date           = date
      @hours          = hours
      @type           = type
      @target_reached = target_reached
      @employee       = employee
    end

    # json view to return what full_calendar is expecting.
    # http://arshaw.com/fullcalendar/docs/event_data/Event_Object/
    def as_json(_options = {})
      {
        title: "#{hours.round(1)} Stunden",
        start: date.iso8601,
        end: date.iso8601,
        allDay: true,
        recurring: false,
        color:,
        url:,
        icon:,
        className: type,
      }
    end

    private

    def color
      if target_reached
        date.on_weekend? ? BLUE : GREEN
      else
        hours == 0 ? RED : ORANGE
      end
    end

    def url
      if type == :activity
        Rails.application.routes.url_helpers.activities_path url_filter
      else
        Rails.application.routes.url_helpers.absences_path url_filter
      end
    end

    def url_filter
      { filter: { from: date, to: date, employee: employee.to_param } }
    end

    def icon
      type == :activity ? 'bolt' : 'hourglass'
    end
  end
end
