class ExpensesController < ApplicationController
  include EntitiesFilterable

  load_and_authorize_resource
  responders :flash

  def index
    @expenses = @expenses.order(date: :desc)
    @expenses = @filter.filter @expenses
    @expenses = @expenses.includes(:employee, :customer, :invoice_effort)
    @total_amount = Money.new @expenses.sum(:amount_cents)
    @expenses = @expenses.paginate(page: params[:page])
  end

  def new
    @expense.employee = current_employee
    @expense.date = Date.today
  end

  def create
    @expense.save
    respond_with @expense, location: expenses_path
  end

  def update
    @expense.update expense_params
    respond_with @expense, location: expenses_path
  end

  def destroy
    @expense.destroy
    respond_with @expense
  end

  private

  def expense_params
    params.require(:expense).permit :name, :employee_id, :customer_id, :text, :date, :note, :amount
  end
end
