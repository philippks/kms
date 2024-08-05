module Invoices
  class PaymentsController < ApplicationController
    load_and_authorize_resource :invoice
    load_and_authorize_resource through: :invoice, class: ::Invoices::Payment

    def index
      @payments = @payments.paginate(page: params[:page])
    end

    def new
      @payment.date = Date.current
      @payment.amount = @invoice.open_amount
    end

    def create
      @payment.save
      respond_with @payment, location: invoice_payments_path unless may_mark_invoice_charged!
    end

    def update
      @payment.update payment_params
      respond_with @payment, location: invoice_payments_path
    end

    def destroy
      @payment.destroy
      respond_with @payment, location: invoice_payments_path
    end

    private

    def payment_params
      params.require(:payment).permit :date, :amount, :mark_invoice_charged_anyway
    end

    def mark_invoice_charged_anyway?
      ActiveRecord::Type::Boolean.new.cast(@payment.mark_invoice_charged_anyway)
    end

    def may_mark_invoice_charged!
      return unless @invoice.valid? && (@invoice.open_amount.zero? || mark_invoice_charged_anyway?)

      @invoice.charge!
      redirect_to @invoice, flash: { notice: t('invoices.payments.create.charged') }
    end
  end
end
