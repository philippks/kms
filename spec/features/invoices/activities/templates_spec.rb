require 'rails_helper'

describe 'Choose Template for Invoice Activity' do
  let(:invoice) { create :invoice, :default_associations }
  let!(:invoice_activity) { create :invoice_activity, text: 'Lala', invoice: }
  let!(:activity_category) { create :activity_category }
  let!(:text_template) { create :text_template, activity_category:, text: 'Gugus' }

  before do
    sign_in invoice.employee
  end

  it 'Select Text Template' do
    visit invoice_activity_templates_path(invoice, invoice_activity)

    click_link 'Auswählen'

    expect(invoice_activity.reload.text).to eq 'Gugus'
    expect(page).to have_current_path invoice_wizard_activities_path(invoice), ignore_query: true
  end
end
