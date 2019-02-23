class VersionsController < ApplicationController
  def index
    @versions = PaperTrail::Version.where(item_type: params[:item_type],
                                          item_id: params[:item_id])
                                   .includes(:item)

    @employees = Employee.find(@versions.map(&:whodunnit).uniq)
    @employee_names = Hash[@employees.collect { |employee| [employee.id.to_s, employee.name] }]

    render :index, format: :html
  end
end
