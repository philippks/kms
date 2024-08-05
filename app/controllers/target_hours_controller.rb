class TargetHoursController < ApplicationController
  respond_to :html, only: :index
  respond_to :json, only: %i[index update]

  def index
    respond_with target_hours if request.format == :json
  end

  def update
    date = Date.parse params[:date]
    target_hours = TargetHours.where(date:).first_or_initialize
    target_hours.increment_hours if target_hours.persisted?
    target_hours.save_or_delete!

    head :ok
  end

  def target_hours
    target_hours = TargetHours.between(from:, to:).to_a
    complete_target_hours target_hours
  end

  # add 8 target hours for each date, where no target hours present
  def complete_target_hours(target_hours)
    (from..to).each do |date|
      next if date.saturday? || date.sunday?

      target_hours.push TargetHours.new(date:, hours: 8) if target_hours.none? { |tg| tg.date == date }
    end

    target_hours
  end

  def from
    @from ||= day_in_month.beginning_of_month
  end

  def to
    @to ||= day_in_month.end_of_month
  end

  # fullcalendar sends first visible date as param start
  # when adding some days, we can be sure, it is in the month
  def day_in_month
    @day_in_month ||= (Date.parse(params['start']) + 10.days)
  end
end
