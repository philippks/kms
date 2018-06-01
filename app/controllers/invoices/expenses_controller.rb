module Invoices
  class ExpensesController < EffortsController
    load_and_authorize_resource :invoice
    load_and_authorize_resource through: :invoice

    respond_to :html

    def create
      @expense.save
      redirect_to invoice_wizard_expenses_path(@invoice)
    end

    def update
      respond_to do |format|
        if @expense.update expense_params
          format.html { redirect_to invoice_wizard_expenses_path(@invoice) }
          format.json { head :no_content }
        else
          format.html { render action: 'index' }
          format.json { render json: @expense.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @expense.destroy
      redirect_to invoice_wizard_expenses_path(@invoice)
    end

    def generate
      Invoices::Expenses::Generate.new(@invoice).generate!
      redirect_to invoice_wizard_expenses_path(@invoice)
    end

    def effort
      @expense
    end

    def effort_params
      expense_params
    end

    def invoice_wizard_path
      invoice_wizard_expenses_path(@invoice)
    end

    private

    def expense_params
      params.require(:expense).permit :invoice_id,
                                      :text,
                                      :amount_manually,
                                      :visible,
                                      :position,
                                      effort_ids: []
    end
  end
end
