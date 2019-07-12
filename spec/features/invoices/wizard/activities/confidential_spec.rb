require 'rails_helper'

feature 'Change Invoice Activity Confidentiality' do
  let(:invoice) { create :invoice, :default_associations, confidential: true }
  let(:activity) do
    create :invoice_activity, invoice: invoice, confidential: false
  end

  before do
    activity.touch

    sign_in invoice.employee
  end

  scenario 'Change confidentiality to true' do
    visit invoice_wizard_activities_path(invoice)

    find('.fa-unlock').find(:xpath, './/..').click

    expect(page).to have_css '.fa-lock'
    expect(activity.reload.confidential?).to eq true
    expect(page).to have_css('td', text: 'Vertrauliche Leistungen')
  end

  scenario 'Change confidentiality to false' do
    activity.update confidential: true
    visit invoice_wizard_activities_path(invoice)

    find('.fa-lock').find(:xpath, './/..').click

    expect(page).to have_css '.fa-unlock'
    expect(activity.reload.confidential?).to eq false
    expect(page).not_to have_css('td', text: 'Vertrauliche Leistungen')
  end
end
