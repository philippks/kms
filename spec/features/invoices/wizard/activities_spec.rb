require 'rails_helper'

feature 'Managing Invoice Activities' do
  let(:employee) { create :employee }
  let(:customer) { create :customer }
  let(:invoice) { create :invoice, employee: employee, customer: customer, date: Date.today }
  let(:text) { 'Some work done' }

  before do
    employee.touch
    invoice.touch

    sign_in employee
  end

  scenario 'List Invoice Activities' do
    2.times do
      activity = create(:activity, :default_associations, hours: 3, hourly_rate: 200)
      create :invoice_activity, invoice: invoice,
                                text: text,
                                hours_manually: 2,
                                efforts: [activity]
    end

    create :activity, :default_associations, hours: 1, hourly_rate: 150

    visit invoice_wizard_activities_path(invoice)

    expect(page).to have_text(text)
    expect(page).to have_text('400.00', count: 2) # amount of invoice activities
    expect(page).to have_text('800.00') # total amount of invoice activities
    expect(page).to have_text("1'200.00") # actual amount of activities
    expect(page).to have_text('150.00') # open activities amount
  end

  scenario 'Add Invoice Activity' do
    visit invoice_wizard_activities_path(invoice)

    expect do
      within 'div.actions' do
        click_link 'Leistung erfassen'
      end
    end.to change { Invoices::Activity.count }.from(0).to(1)
  end

  scenario 'Delete Invoice Activity' do
    invoice_activity = create :invoice_activity, invoice: invoice

    visit invoice_wizard_activities_path(invoice)

    expect do
      click_link "delete-invoice-activity-#{invoice_activity.id}-link"
    end.to change { Invoices::Activity.count }.from(1).to(0)
  end
end
