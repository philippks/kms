class DebtorsReportsController < ApplicationController
  def index; end

  def new
    @until_date = until_date
    @debtors = debtors
    @overdues = overdues

    respond_to do |format|
      format.html {}
      format.pdf do
        render pdf: file_name, orientation: :landscape, disposition: :attachment
      end
    end
  end

  def create
    redirect_to new_debtors_report_path(debtors_report: { until_date: })
  end

  private

  def until_date
    if params.dig(:debtors_report, :until_date)
      Date.parse(report_params[:until_date])
    else
      Date.current
    end
  end

  def debtors
    @debtors ||= Invoice.before(@until_date)
                        .where(state: :sent)
                        .includes(:customer, :payments)
                        .order('customers.name ASC', date: :desc)
  end

  def overdues
    @overdues ||= debtors.each_with_object({}) do |debtor, hash|
      hash[debtor] = (@until_date - debtor.date).to_i
      hash
    end
  end

  def file_name
    I18n.t 'debtors_reports.new.filename', until: I18n.l(until_date, format: :short)
  end

  def report_params
    params.require(:debtors_report).permit(:until_date)
  end
end
