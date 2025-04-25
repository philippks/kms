class AbsencesController < ApplicationController
  include EntitiesFilterable

  load_and_authorize_resource
  responders :flash

  def index
    @absences = @absences.order(from_date: :desc, created_at: :desc)
    @absences = @filter.filter @absences
    @absences = @absences.paginate(page: params[:page])
    @absences = @absences.includes(:employee)
  end

  def new
    @absence.employee = current_employee
    @absence.reason = Absence.reason.find_value(params['reason'].to_i) if params['reason']
    @absence.from_date = Date.current
    @absence.to_date = Date.current
    @absence.hours = AbsencesService.new.calculate_default_hours(@absence.from_date, @absence.to_date, current_employee)
  end

  def create
    @absence.save
    respond_with @absence, location: absences_path
  end

  def update
    @absence.update absence_params
    respond_with @absence, location: absences_path
  end

  def destroy
    @absence.destroy
    respond_with @absence
  end

  def default_hours
    from_date = Date.parse(default_hours_params[:from_date])
    to_date = Date.parse(default_hours_params[:to_date])

    default_hours = AbsencesService.new.calculate_default_hours(from_date, to_date, current_employee)

    render json: { default_hours: }
  end

  private

  def absence_params
    params.require(:absence).permit :employee_id, :text, :date, :hours, :from_date, :to_date, :reason
  end

  def default_hours_params
    params.require(:absence).permit :from_date, :to_date
  end
end
