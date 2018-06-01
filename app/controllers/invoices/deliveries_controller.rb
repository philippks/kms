module Invoices
  class DeliveriesController < ApplicationController
    load_and_authorize_resource :invoice

    def new
    end

    def update
      if @invoice.update delivery_params.merge(delivery_method: delivery_method)
        case delivery_method
        when :post
          @invoice.deliver!
          flash[:success] = t('.post_delivery_success')
          redirect_to invoice_path(@invoice)
        when :email
          redirect_to new_invoice_mail_path(@invoice)
        end
      else
        render :new
      end
    end

    private

    def delivery_method
      delivery_params[:customer_attributes][:invoice_delivery].to_sym
    end

    def delivery_params
      params.require(:delivery).permit customer_attributes: [:id,
                                                             :invoice_delivery,
                                                             :confidential_title,
                                                             :email_address]
    end
  end
end
