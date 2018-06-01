require 'rails_helper'

feature 'Wizard, Invoice Activities' do
  let(:invoice_activity) do
    create :invoice_activity, :default_associations, efforts: [
      create(:activity, :default_associations, text: 'Huhu'),
      create(:activity, :default_associations, text: 'Hehe')
    ]
  end

  before do
    invoice_activity.touch

    sign_in invoice_activity.invoice.employee
  end

  scenario 'User ungroups grouped invoice activity' do
    visit invoice_wizard_activities_path(invoice_activity.invoice)

    expect do
      click_link 'Gruppierung aufheben'
    end.to change { Invoices::Activity.count }.from(1).to(2)

    expect(page).to have_text 'Huhu'
    expect(page).to have_text 'Hehe'
    expect(page).not_to have_css('option.fa-unlink')
  end
end
