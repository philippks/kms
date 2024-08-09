class ActivitiesController < ApplicationController
  include EntitiesFilterable

  load_and_authorize_resource
  responders :flash

  def index
    @activities = @activities.order(date: :desc, created_at: :desc)
    @activities = @filter.filter @activities
    @activities = @activities.includes(:employee, :customer, :invoice_effort, :activity_category)
    @total_hours = @activities.sum(:hours)
    @total_amount = Money.new(@activities.sum(:amount_cents))

    respond_to do |format|
      format.html do
        @activities = @activities.paginate(page: params[:page])
      end

      format.pdf do
        render pdf: export_file_name, orientation: :landscape, disposition: :attachment, zoom: 0.65
      end

      format.csv do
        send_data ActivitiesCsv.new.to_csv(@activities), filename: "#{export_file_name}.csv"
      end
    end
  end

  def new
    @activity.employee = current_employee
    @activity.customer = Customer.find(params[:customer])
    @activity.date = Date.today
    @activity.hourly_rate = hourly_rate_for_new_activity
  end

  def create
    @activity.save
    respond_with @activity, location: activities_path
  end

  def update
    @activity.update activity_params
    respond_with @activity, location: activities_path
  end

  def destroy
    @activity.destroy
    respond_with @activity
  end

  private

  def default_filter
    { employee: current_employee.id, from: Date.current }
  end

  def activity_params
    params.require(:activity).permit :employee_id,
                                     :customer_id,
                                     :text,
                                     :date,
                                     :note,
                                     :hours,
                                     :activity_category_id,
                                     :hourly_rate
  end

  def hourly_rate_for_new_activity
    if params[:customer]
      if hourly_rate = HourlyRate.find_by(customer_id: params[:customer],
                                          employee: current_employee)
        return hourly_rate.hourly_rate
      elsif Customer.find(params[:customer]).customer_group&.not_chargeable?
        return 0
      end
    end

    current_employee.hourly_rate
  end

  def export_file_name
    I18n.t 'activities.index.export_filename'
  end
end
