require 'rails_helper'

RSpec.describe Invoices::WizardController do
  let(:invoice) do
    create :invoice, :with_associations, id: 1337
  end

  before do
    sign_in invoice.employee
  end

  describe 'GET #activities' do
    let(:confidential_activity) { create :invoice_activity, confidential: true, invoice:, position: 1 }
    let(:activity) { create :invoice_activity, invoice:, position: 1 }
    let(:second_activity) { create :invoice_activity, invoice:, position: 2 }

    it 'assigns invoice activities in correct order' do
      get :activities, params: { invoice_id: invoice.to_param }

      expect(assigns(:activities)).to eq [activity, second_activity, confidential_activity]
    end
  end

  describe 'PATCH #update' do
    subject do
      patch :update, params: parameters
    end

    let(:parameters) do
      {
        invoice_id: invoice.to_param,
        invoice: { title: 'Huhu' },
        current_wizard_action: :complete,
      }
    end

    it 'updates the invoice' do
      expect { subject }.to change { invoice.reload.title }.to 'Huhu'
    end

    it 'redirects to invoice' do
      expect(subject).to redirect_to invoice_path(invoice)
    end

    context 'with provided redirection' do
      let(:parameters) do
        {
          activities: 'Leistungen gruppieren',
          invoice_id: invoice.to_param,
          invoice: { title: 'Huhu' },
        }
      end

      it 'redirects to provided step' do
        expect(subject).to redirect_to invoice_wizard_activities_path(invoice)
      end
    end
  end

  describe 'PATCH #update customer_attributes' do
    subject do
      patch :update, params: {
        invoice_id: invoice.to_param,
        invoice: { customer_attributes: { address: 'Huhu' } },
        current_wizard_action: :complete,
      }
    end

    it 'updates the customer' do
      expect { subject }.to change { invoice.customer.reload.address }.to 'Huhu'
    end
  end
end
