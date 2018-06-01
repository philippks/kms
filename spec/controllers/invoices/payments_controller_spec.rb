require 'rails_helper'

RSpec.describe Invoices::PaymentsController do
  let(:invoice) do
    create :invoice, :default_associations, state: :sent, activities_amount_manually: 500
  end
  let(:payment) { create :payment, invoice: invoice, amount: 200 }

  before do
    sign_in invoice.employee
  end

  describe 'GET #index' do
    it 'lists all payments' do
      payment = create :payment, amount: 200, invoice: invoice
      get :index, params: { invoice_id: invoice }
      expect(assigns(:payments)).to eq [payment]
    end
  end

  describe 'GET #new' do
    it 'assigns a new part payment' do
      get :new, params: { invoice_id: invoice }

      expect(assigns(:payment)).to be_a_new Invoices::Payment
      expect(assigns(:payment).date).to eq Date.current
    end
  end

  describe 'POST #create' do
    let(:payment_params) { { date: '2016-01-01', amount: '200' } }

    it 'creates a new part payment' do
      expect do
        post :create, params: { invoice_id: invoice, payment: payment_params }
      end.to change(Invoices::Payment, :count).by(1)
    end

    context 'if amount equals total invoice amount' do
      let(:payment_params) { { date: '2016-01-01', amount: invoice.total_amount } }

      it 'marks invoice as charged' do
        expect do
          post :create, params: { invoice_id: invoice, payment: payment_params }
        end.to change { invoice.reload.state.to_sym }.from(:sent).to(:charged)
      end

      it 'redirects to invoice' do
        post :create, params: { invoice_id: invoice, payment: payment_params }

        expect(response).to redirect_to invoice_path(invoice)
      end
    end

    context 'if amount is larger than invoice amount' do
      let(:payment_params) { { amount: invoice.total_amount + Money.from_amount(100) } }

      it 'has validation error' do
        post :create, params: { invoice_id: invoice, payment: payment_params }

        expect(assigns(:payment).errors).to_not be_empty
      end
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested payment' do
      get :edit, params: { invoice_id: invoice, id: payment }
      expect(assigns(:payment)).to eq payment
    end
  end

  describe 'PATCH #update' do
    let(:update_params) do
      { id: payment, invoice_id: invoice, payment: { amount: '300' } }
    end

    it 'updates the payment' do
      expect do
        patch :update, params: update_params
      end.to change { payment.reload.amount }.to(Money.from_amount(300))
    end
  end

  describe 'DELETE #destroy' do
    before do
      payment.touch
    end

    it 'destroys a payment' do
      expect do
        delete :destroy, params: { invoice_id: invoice, id: payment }
      end.to change(Invoices::Payment, :count).by(-1)
    end
  end
end
