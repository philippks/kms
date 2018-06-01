require 'rails_helper'

feature 'Choose Template for Invoice Activity' do
  let(:invoice) { create :invoice, :default_associations }
  let!(:invoice_activity) { create :invoice_activity, text: 'Lala', invoice: invoice }
  let!(:activity_category) { create :activity_category }
  let!(:text_template) { create :text_template, activity_category: activity_category, text: 'Gugus' }

  before do
    sign_in invoice.employee
  end

  scenario 'Select Text Template' do
    visit invoice_activity_templates_path(invoice, invoice_activity)

    click_link 'Auswählen'

    expect(invoice_activity.reload.text).to eq 'Gugus'
    expect(page.current_path).to eq invoice_wizard_activities_path(invoice)
  end
end
