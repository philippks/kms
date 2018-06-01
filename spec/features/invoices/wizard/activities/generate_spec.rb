require 'rails_helper'

feature 'Manage Invoice Activities' do
  let(:invoice) { create :invoice, :default_associations }
  let!(:activity) do
    create :activity, :default_associations, text: 'Something done',
                                             date: 10.day.ago
  end

  before do
    sign_in invoice.employee
  end

  scenario 'Generate Invoice Activities' do
    visit invoice_wizard_activities_path(invoice)

    click_link 'Leistungen generieren'

    aggregate_failures 'generated invoice activity' do
      expect(Invoices::Activity.count).to eq 1
      expect(Invoices::Activity.last.text).to eq 'Something done'
      expect(Invoices::Activity.last.efforts).to eq [activity]
      expect(current_path).to eq invoice_wizard_activities_path(invoice)
    end
  end
end
