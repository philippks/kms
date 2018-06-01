class CustomerGroupsController < ApplicationController
  load_and_authorize_resource
  responders :flash

  def index
    @customer_groups = @customer_groups.paginate(page: params[:page])
    @customer_groups = @customer_groups.order(:name)
  end

  def create
    @customer_group.save
    respond_with @customer_group, location: customer_groups_path
  end

  def update
    @customer_group.update customer_group_params
    respond_with @customer_group, location: customer_groups_path
  end

  def destroy
    @customer_group.destroy
    respond_with @customer_group
  end

  private

  def customer_group_params
    params.require(:customer_group).permit :name, :not_chargeable
  end
end
