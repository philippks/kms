module Invoices
  class MailsController < ApplicationController
    load_and_authorize_resource :invoice
    load_and_authorize_resource through: :invoice, class: ::Invoices::Mail, singleton: true

    def show; end

    def new
      @mail.body = new_body
      @mail.employee = current_employee
      @mail.from = Global.mailer.from
      @mail.to = @invoice.customer.email_address

      render :new, format: :html
    end

    def create
      if @mail.save && deliver_invoice
        flash[:notice] = t('.success')
        redirect_to invoice_path(@invoice)
      else
        flash[:danger] = t('.error')
        render :new
      end
    end

    private

    def new_body
      ERB.new(File.read(body_template_path)).result(binding)
    end

    def body_template_path
      Rails.root.join('app/views/invoices/mails/body.text.erb')
    end

    def mail_params
      params.require(:mail).permit(:body, :from, :to, :employee_id)
    end

    def deliver_invoice
      return false unless @invoice.may_deliver?

      @invoice.deliver!

      begin
        ::InvoiceMailer.invoice_mail(@invoice, @mail.body).deliver_now
      rescue StandardError => e
        @invoice.reopen!
        raise e
      end
    end
  end
end
