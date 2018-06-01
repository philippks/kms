class Hours
  class CalendarEventsController < ApplicationController
    respond_to :json

    def index
      render json: events
    end

    private

    def events
      calendar_days.map(&:events).flatten
    end

    def calendar_days
      factory.build_calendar_days
    end

    def factory
      Hours::CalendarDayFactory.new employee: current_employee,
                                    from: Date.parse(params[:from]),
                                    to: Date.parse(params[:to])
    end
  end
end
