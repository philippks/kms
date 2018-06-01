require 'rails_helper'

RSpec.describe Invoices::ExpensesController do
  let(:invoice) { create :invoice, :default_associations }
  let!(:first_invoice_expense) { create :invoice_expense, invoice: invoice }
  let!(:second_invoice_expense) { create :invoice_expense, invoice: invoice }

  before do
    sign_in invoice.employee
  end

  describe 'PATCH #update' do
    subject do
      patch :update, params: {
        format: format,
        invoice_id: invoice,
        id: first_invoice_expense.to_param,
        expense: { text: 'Eifach öpis' }
      }
    end

    context 'html' do
      let(:format) { :html }

      it 'updates invoice expense' do
        expect { subject }.to change { first_invoice_expense.reload.text }.to('Eifach öpis')
      end

      it 'redirects back to wizard' do
        subject

        expect(response).to redirect_to invoice_wizard_expenses_path(invoice)
      end
    end

    context 'json' do
      let(:format) { :json }

      it 'returns 204' do
        subject

        expect(response.status).to eq 204
      end
    end
  end

  describe 'PATCH #reorder' do
    it 'reorders the invoice effort' do
      patch :reorder, params: {
        invoice_id: invoice.to_param,
        id: first_invoice_expense.to_param,
        expense_id: first_invoice_expense.to_param,

        expense: {
          position: 2,
        }
      }

      expect(first_invoice_expense.reload.position).to eq 2
      expect(second_invoice_expense.reload.position).to eq 1
    end
  end

  describe 'POST #group' do
    let(:expense_ids) { [first_invoice_expense.id, second_invoice_expense.id] }
    let(:service) { instance_double Invoices::Efforts::Group }

    subject do
      patch :group, params: {
        invoice_id: invoice.to_param,
        effort_ids: expense_ids,
      }
    end

    it 'calls service to group expenses' do
      expect(Invoices::Efforts::Group).to receive(:new).with(invoice, expense_ids).and_return service
      expect(service).to receive(:group_efforts!)

      subject
    end
  end
end
