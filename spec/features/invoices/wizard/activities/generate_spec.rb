require 'rails_helper'

describe 'Manage Invoice Activities' do
  let(:invoice) { create :invoice, :default_associations }
  let!(:activity) do
    create :activity, :default_associations, text: 'Something done',
                                             date: 10.days.ago
  end

  before do
    sign_in invoice.employee
  end

  it 'Generate Invoice Activities' do
    visit invoice_wizard_activities_path(invoice)

    click_link 'Leistungen generieren'

    aggregate_failures 'generated invoice activity' do
      expect(Invoices::Activity.count).to eq 1
      expect(Invoices::Activity.last.text).to eq 'Something done'
      expect(Invoices::Activity.last.efforts).to eq [activity]
      expect(page).to have_current_path invoice_wizard_activities_path(invoice), ignore_query: true
    end
  end
end
