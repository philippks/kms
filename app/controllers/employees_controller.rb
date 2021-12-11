class EmployeesController < ApplicationController
  load_and_authorize_resource
  responders :flash

  def index
    @employees = @employees.active unless params[:deactivated]
    @employees = @employees.for_query(params[:query])
    @employees = @employees.order(:name)
  end

  def create
    @employee.save
    respond_with @employee, location: employees_path
  end

  def update
    @employee.update employee_params
    respond_with @employee, location: employees_path
  end

  def destroy
    @employee.destroy
    respond_with @employee
  end

  private

  def employee_params
   employee_params = params.require(:employee).permit :name,
                                                      :email,
                                                      :initials,
                                                      :hourly_rate,
                                                      :worktime_model,
                                                      :workload,
                                                      :password,
                                                      :password_confirmation,
                                                      :deactivated

   if employee_params[:password].blank?
     employee_params.delete :password
   end

   employee_params
  end
end
