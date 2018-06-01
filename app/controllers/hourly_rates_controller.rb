class HourlyRatesController < ApplicationController
  load_and_authorize_resource :employee
  load_and_authorize_resource through: :employee

  def index
    @hourly_rates = @hourly_rates.includes(:customer)
    @hourly_rates = @hourly_rates.order('customers.name')
  end

  def new
  end

  def create
    @hourly_rate.save
    respond_with @hourly_rate, location: employee_hourly_rates_path(@employee)
  end

  def update
    @hourly_rate.update hourly_rate_params
    respond_with @hourly_rate, location: employee_hourly_rates_path(@employee)
  end

  def destroy
    @hourly_rate.destroy
    respond_with @hourly_rate, location: employee_hourly_rates_path(@employee)
  end

  def hourly_rate_params
    params.require(:hourly_rate).permit :customer_id, :hourly_rate
  end
end
