require 'rails_helper'

feature 'Change Invoice Activity Visibility' do
  let(:invoice) { create :invoice, :default_associations }
  let(:activity) do
    create :invoice_activity, invoice: invoice, visible: true
  end

  before do
    activity.touch

    sign_in invoice.employee
  end

  scenario 'Change visibility to false' do
    visit invoice_wizard_activities_path(invoice)

    find('.fa-eye').find(:xpath, './/..').click

    expect(page).to have_css '.fa-eye-slash'
    expect(activity.reload.visible?).to eq false
  end

  scenario 'Change visibility to true' do
    activity.update visible: false
    visit invoice_wizard_activities_path(invoice)

    find('.fa-eye-slash').find(:xpath, './/..').click

    expect(page).to have_css '.fa-eye'
    expect(activity.reload.visible?).to eq true
  end
end
