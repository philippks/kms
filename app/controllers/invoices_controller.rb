class InvoicesController < ApplicationController
  include EntitiesFilterable

  load_and_authorize_resource

  respond_to :html
  respond_to :json, only: [:update]

  def index
    @invoices = @invoices.order(Arel.sql("(CASE state WHEN 'open' THEN 1 ELSE 2 END), date DESC, created_at DESC"))
    @invoices = @filter.filter @invoices

    @total_amount = Money.new(@invoices.sum(:persisted_total_amount_cents))

    @invoices = @invoices.includes(:customer, :employee)
    @invoices = @invoices.paginate(page: params[:page])

    respond_to do |format|
      format.html do
        @invoices = @invoices.paginate(page: params[:page])
      end

      format.pdf do
        render pdf: export_file_name, orientation: :landscape, disposition: :attachment, zoom: 0.65
      end

      format.xls do
        response.headers['Content-Disposition'] =
          "attachment; filename=#{export_file_name}.xls"
      end
    end
  end

  def show
    @open_efforts_before_invoice_date_exists = ::Effort.for_customer(@invoice.customer)
                                                       .before(@invoice.date)
                                                       .for_state(:open)
                                                       .any?
  end

  def new
    @invoice.date = Date.today
    @invoice.vat_rate = Global.invoices.default_vat_rate
    @invoice.employee = current_employee
  end

  def create
    @invoice.created_by_initials = @invoice.employee.initials.downcase
    @invoice.save
    Invoices::Activities::Generate.new(@invoice).generate!
    Invoices::Expenses::Generate.new(@invoice, generate_default_expense: true).generate!
    respond_with @invoice
  end

  def update
    respond_to do |format|
      if @invoice.update invoice_params
        format.html { redirect_to invoice_path(@invoice) }
        format.json { head :no_content }
      else
        format.html { render action: 'index' }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @invoice.destroy
    respond_with @invoice, location: invoices_path
  end

  def deliver
    flash[:notice] = t('.success') if @invoice.deliver!
    redirect_to invoice_path(@invoice)
  end

  def charge
    flash[:notice] = t('.success') if @invoice.charge!
    redirect_to invoice_path(@invoice)
  end

  def reopen
    flash[:notice] = t('.success') if @invoice.reopen!
    redirect_to invoice_path(@invoice)
  end

  private

  def invoice_params
    params.require(:invoice).permit :employee_id,
                                    :customer_id,
                                    :created_by_initials,
                                    :date,
                                    :vat_rate,
                                    :title,
                                    :activities_amount_manually
  end

  def export_file_name
    I18n.t 'invoices.index.export_filename'
  end
end
