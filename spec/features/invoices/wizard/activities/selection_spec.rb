require 'rails_helper'

describe 'Select Activities' do
  let(:invoice) { create :invoice, :default_associations }
  let(:invoice_activity) { create :invoice_activity, invoice: }
  let(:activity) { create(:activity, :default_associations) }

  before do
    invoice_activity.touch
    activity.touch

    sign_in invoice.employee
  end

  it 'Select Activities for Invoice Activity' do
    visit edit_invoice_activity_path(invoice, invoice_activity)

    page.check('activity[effort_ids][]')
    click_button 'Rechnungsleistung aktualisieren'

    expect(invoice_activity.reload.efforts).to eq [activity]
  end

  it 'De-Select Activity for Invoice Activity' do
    invoice_activity.update efforts: [activity]
    visit edit_invoice_activity_path(invoice, invoice_activity)

    page.uncheck('activity[effort_ids][]')
    click_button 'Rechnungsleistung aktualisieren'

    expect(invoice_activity.reload.efforts).to eq []
  end
end
