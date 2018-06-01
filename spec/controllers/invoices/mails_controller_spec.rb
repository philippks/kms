require 'rails_helper'

RSpec.describe Invoices::MailsController do
  let(:customer) { create :customer, name: 'Hans Muster', confidential_title: 'Hansi', email_address: 'hans@muster.ch' }
  let(:employee) { create :employee }
  let(:invoice) { create :invoice, customer: customer, employee: employee, state: :open }

  before do
    sign_in employee
  end

  describe 'GET #new' do
    it 'assigns invoice mail with default body' do
      get :new, params: { invoice_id: invoice.to_param }

    expect(assigns(:mail).body).to eq("""Guten Tag Hansi

In der Beilage erhalten Sie unsere Rechnung vom 22. März 2015 mit der Bitte um fristgerechte Begleichung.

Wir bedanken uns für das entgegengebrachte Vertrauen.

Freundliche Grüsse
""")
    end

    context 'without confidential title' do
      let(:customer) do
        create :customer, name: 'Hans Muster',
                          confidential_title: '',
                          email_address: 'hans@muster.ch'
      end

      it 'uses the customers name' do
        get :new, params: { invoice_id: invoice.to_param }

        expect(assigns(:mail).body).to include("Guten Tag Hans Muster")
      end
    end
  end

  describe 'POST #create' do
    let(:parameters) do
      {
        invoice_id: invoice.to_param,
        mail: {
          employee_id: employee.id,
          from: Global.mailer.from,
          to: customer.email_address,
          body: 'Some body'
        }
      }
    end


    before do
      allow_any_instance_of(Invoice).to receive(:persist_pdf) # ignore persist
      FileUtils.touch Invoices::PDF.new(invoice).persisted_pdf_path
    end

    it 'saves invoice mail' do
      post :create, params: parameters

      mail = Invoices::Mail.last
      expect(mail.invoice).to eq invoice
      expect(mail.body).to eq 'Some body'
      expect(mail.from).to eq Global.mailer.from
      expect(mail.to).to eq customer.email_address
      expect(mail.employee_id).to eq employee.id
    end

    it 'redirects back to invoice' do
      post :create, params: parameters

      expect(response).to redirect_to invoice_path(invoice)
    end

    it 'changes state of invoice' do
      expect do
        post :create, params: parameters
      end.to change { invoice.reload.state.to_sym }.from(:open).to(:sent)
    end

    context 'if invoice state change not possible' do
      let(:invoice) { create :invoice, customer: customer, employee: employee, state: :sent }

      it 'does not send a mail' do
        expect do
          post :create, params: parameters
        end.to_not change { ActionMailer::Base.deliveries.size }
      end
    end

    context 'mailer raises an exception' do
      before do
        expect(InvoiceMailer).to receive(:invoice_mail).and_raise Net::SMTPAuthenticationError
      end

      it 'does not change state of invoice to sent' do
        expect do
          post :create, params: parameters
        end.to raise_error Net::SMTPAuthenticationError

        expect(invoice.reload.state.to_sym).to eq :open
      end
    end
  end
end
