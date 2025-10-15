require 'rails_helper'

RSpec.describe Invoices::ActivitiesController do
  let(:invoice) { create :invoice, :default_associations }
  let!(:first_invoice_activity) { create :invoice_activity, invoice: }
  let!(:second_invoice_activity) { create :invoice_activity, invoice: }

  before do
    sign_in invoice.employee
  end

  describe 'PATCH #update' do
    subject do
      patch :update, params: {
        format:,
        invoice_id: invoice.to_param,
        id: first_invoice_activity.to_param,
        activity: { text: 'Eifach öpis' },
      }
    end

    context 'html' do
      let(:format) { :html }

      it 'updates invoice activity' do
        expect { subject }.to change { first_invoice_activity.reload.text }.to('Eifach öpis')
      end

      it 'redirects back to wizard' do
        subject

        expect(response).to redirect_to invoice_wizard_activities_path(invoice)
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

  describe 'PATCH #toggle_pagebreak' do
    before do
      first_invoice_activity.update pagebreak: false
    end

    it 'toggles pagebreak' do
      patch :toggle_pagebreak, params: {
        invoice_id: invoice,
        id: first_invoice_activity,
        activity_id: first_invoice_activity,
      }

      expect(first_invoice_activity.reload.pagebreak).to be true
    end
  end

  describe 'PATCH #reorder' do
    it 'reorders the invoice effort' do
      patch :reorder, params: {
        invoice_id: invoice.to_param,
        id: first_invoice_activity.to_param,
        activity_id: first_invoice_activity.to_param,

        activity: {
          position: 2,
        },
      }

      expect(first_invoice_activity.reload.position).to eq 2
      expect(second_invoice_activity.reload.position).to eq 1
    end
  end

  describe 'POST #group' do
    subject do
      patch :group, params: {
        invoice_id: invoice.to_param,
        effort_ids: activity_ids,
      }
    end

    let(:activity_ids) { [first_invoice_activity.id, second_invoice_activity.id] }
    let(:service) { instance_double Invoices::Efforts::Group }

    it 'calls service to group activities' do
      expect(Invoices::Efforts::Group).to receive(:new).with(invoice, activity_ids).and_return service
      expect(service).to receive(:group_efforts!)

      subject
    end
  end
end
