require 'rails_helper'

RSpec.describe Invoices::DeliveriesController do
  let(:invoice) { create :invoice, :default_associations }
  let(:customer) { invoice.customer.reload }

  before do
    sign_in invoice.employee
  end

  describe 'PUT #update' do
    let(:delivery_method) { :email }
    let(:parameters) do
      {
        invoice_id: invoice.to_param,
        delivery: {
          customer_attributes: {
            invoice_delivery: delivery_method,
            email_address: 'asdf@asdf.ch',
          },
        },
      }
    end

    it 'updates customers attributes' do
      put :update, params: parameters

      expect(customer.invoice_delivery.to_sym).to eq :email
      expect(customer.email_address).to eq 'asdf@asdf.ch'
    end

    it 'updates delivery_method of invoice' do
      expect do
        put :update, params: parameters
      end.to change { invoice.reload.delivery_method.to_sym }.to :email
    end

    context 'with delivery_method :email' do
      let(:delivery_method) { :email }

      it 'redirects to create new invoice mail' do
        put :update, params: parameters

        expect(response).to redirect_to new_invoice_mail_path(invoice)
      end
    end

    context 'with delivery_method :post' do
      let(:delivery_method) { :post }

      it 'redirects back to invoice' do
        put :update, params: parameters

        expect(response).to redirect_to invoice_path(invoice)
      end
    end

    context 'with invalid parameters' do
      let(:parameters) do
        {
          invoice_id: invoice.to_param,
          delivery: {
            customer_attributes: {
              invoice_delivery: :mail,
              email_address: '',
            },
          },
        }
      end

      it 'renders new' do
        put :update, params: parameters

        expect(response).to render_template :new
      end
    end
  end
end
