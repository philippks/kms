class OpListsController < ApplicationController
  def new
    @filter = filter
    @highlighted_employee_id = filter.employee || current_employee.id
    @op_list_items = OpListItem.build_for(employee_id: filter.employee, until_date: filter.until_date)
    @op_list_items.sort_by! { |item| item.customer.name.downcase }
    @total_open_amount = @op_list_items.sum(&:amount)

    respond_to do |format|
      format.html {}
      format.pdf do
        render pdf: file_name, disposition: :attachment, zoom: 0.65
      end
    end
  end

  private

  def file_name
    I18n.t 'op_lists.new.filename', date: I18n.l(filter.until_date)
  end

  def filter
    OpenStruct.new(
      employee: filter_params[:employee].present? ? filter_params[:employee].to_i : nil,
      until_date: filter_params[:until_date].present? ? Date.parse(filter_params[:until_date]) : Date.current
    )
  end

  def filter_params
    params[:filter] ? params[:filter].permit(:employee, :until_date) : { employee: nil }
  end
end
