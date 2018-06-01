class CustomersController < ApplicationController
  include EntitiesFilterable

  load_and_authorize_resource

  def index
    respond_to do |format|
      format.json do
        @customers = Customer.for_query(params['query']) if params['query']
        @customers = @customers.active if params[:active]
        @customers = @customers.order(:name)
      end
      format.html do
        @customers = @filter.filter @customers
        @customers = @customers.includes(:customer_group)
                               .order(:name)
                               .paginate(page: params[:page])
      end
    end
  end

  def create
    @customer.save
    respond_with @customer, location: customers_path
  end

  def update
    @customer.update customer_params
    respond_with @customer, location: customers_path
  end

  def destroy
    @customer.destroy
    respond_with @customer
  end

  private

  def customer_params
    params.require(:customer).permit :name,
                                     :address,
                                     :confidential_title,
                                     :email_address,
                                     :customer_group_id,
                                     :deactivated,
                                     :invoice_delivery,
                                     :invoice_hint
  end
end
