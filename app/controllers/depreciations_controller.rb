class DepreciationsController < ApplicationController
  include EntitiesFilterable

  load_and_authorize_resource

  respond_to :html

  def index
    @depreciations = @depreciations.paginate(page: params[:page])
  end

  def show
    @activities = @depreciation.efforts.includes(:employee, :customer)
  end

  def new
    @depreciation.employee = current_employee
    @depreciation.customer = Customer.find(params[:customer])
    @depreciation.date = Date.current
    @activities = Activity.for_state(:open)
                          .includes(:customer, :employee)
                          .where('amount_cents > 0')
                          .where(customer: params[:customer])
  end

  def create
    @depreciation.save
    respond_with @depreciation, location: depreciations_path
  end

  def destroy
    @depreciation.destroy
    respond_with @depreciation
  end

  private

  def depreciation_params
    params.require(:depreciation).permit :customer_id,
                                         :employee_id,
                                         :date,
                                         :text,
                                         effort_ids: []
  end
end
