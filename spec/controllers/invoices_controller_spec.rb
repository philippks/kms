require 'rails_helper'

RSpec.describe InvoicesController do
  let(:invoice) { create :invoice, :default_associations, date: 5.days.ago, state: :charged }

  before do
    sign_in invoice.employee
  end

  describe 'GET #index' do
    it 'lists invoices' do
      get :index
      expect(assigns(:invoices)).to eq [invoice]
    end

    describe 'order' do
      it 'orders invoices by date' do
        second_invoice = create :invoice, :default_associations, date: 10.days.ago, state: :charged
        get :index
        expect(assigns(:invoices)).to eq [invoice, second_invoice]
      end
    end
  end

  describe 'POST #create' do
    let(:customer) { create :customer }
    let(:employee) { create :employee, initials: 'EK' }

    let(:invoice_params) do
      {
        customer_id: customer.id,
        employee_id: employee.id,
        date: Date.current,
        vat_rate: Settings.default_vat_rate,
      }
    end

    it 'creates invoice' do
      expect do
        post :create, params: { invoice: invoice_params }
      end.to change(Invoice, :count).by 1
    end

    it 'sets created_by_initials to employee initials' do
      post :create, params: { invoice: invoice_params }

      expect(Invoice.last.created_by_initials).to eq 'ek'
    end

    context 'with activities' do
      let!(:activity) do
        create :activity, employee:, customer:, hours: 1
      end

      it 'generates activities' do
        post :create, params: { invoice: invoice_params }

        expect(Invoice.last.activities.length).to eq 1
        expect(Invoice.last.activities.first.efforts).to eq [activity]
      end
    end
  end

  describe 'PATCH #update' do
    subject do
      patch :update, params: {
        format:,
        id: invoice.to_param,
        invoice: { title: 'Spezialrechnung' },
      }
    end

    context 'html' do
      let(:format) { :html }

      it 'updates invoice' do
        expect { subject }.to change { invoice.reload.title }.to('Spezialrechnung')
      end

      it 'redirects back to wizard' do
        subject

        expect(response).to redirect_to invoice_path(invoice)
      end
    end

    context 'json' do
      let(:format) { :json }

      it 'returns 204' do
        subject

        expect(response).to have_http_status :no_content
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys a invoice' do
      invoice = create :invoice, :default_associations
      expect do
        delete :destroy, params: { id: invoice.to_param }
      end.to change(Invoice, :count).by(-1)
    end
  end

  describe 'PATCH #deliver' do
    let(:invoice) { create :invoice, :default_associations, state: :open }

    before do
      allow_any_instance_of(Invoice).to receive(:persist_pdf) # ignore persist
    end

    it 'changes state to sent' do
      expect do
        patch :deliver, params: { id: invoice.to_param }
      end.to change { invoice.reload.state.to_sym }.from(:open).to(:sent)
    end

    it 'redirects to show invoice' do
      patch :deliver, params: { id: invoice.to_param }
      expect(response).to redirect_to invoice_path(invoice)
    end
  end

  describe 'PATCH #charge' do
    let(:invoice) { create :invoice, :default_associations, state: :sent }

    it 'changes state to charged' do
      expect do
        patch :charge, params: { id: invoice.to_param }
      end.to change { invoice.reload.state.to_sym }.from(:sent).to(:charged)
    end

    it 'redirects to show invoice' do
      patch :charge, params: { id: invoice.to_param }
      expect(response).to redirect_to invoice_path(invoice)
    end
  end

  describe 'PATCH #reopen' do
    let(:invoice) { create :invoice, :default_associations, state: :charged }

    it 'changes state to open' do
      expect do
        patch :reopen, params: { id: invoice.to_param }
      end.to change { invoice.reload.state.to_sym }.from(:charged).to(:open)
    end

    it 'redirects to show invoice' do
      patch :reopen, params: { id: invoice.to_param }
      expect(response).to redirect_to invoice_path(invoice)
    end
  end
end
