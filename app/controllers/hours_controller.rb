class HoursController < ApplicationController
  respond_to :html

  def index
    @current_month = params['month'] ? Date.parse(params['month']) : Date.current.beginning_of_month

    @target_hours = TargetHours.hours_between_for_employee from: range[:from], to: range[:to], employee: current_employee
    @total_activities = Activity.for_employee(current_employee)
                                .between(range)
                                .sum(:hours)
    total_absences = Absence.for_employee(current_employee)
                             .between(range)
                             .sum { |absence| absence.absent_target_hours(range) }
    @total_absences = total_absences * current_employee.workload_in_percent
  end

  private

  def range
    { from: @current_month.beginning_of_month, to: @current_month.end_of_month }
  end
end
