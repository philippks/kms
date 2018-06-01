require 'rails_helper'

feature 'Managing Activities' do
  let(:text) { 'Einfach etwas' }
  let(:employee) { create :employee }
  let!(:customer) { create :customer, name: 'Max' }
  let!(:activity) { create :activity, customer: customer, employee: employee, text: text }

  before do
    sign_in employee
  end

  scenario 'Create new Activity' do
    visit new_activity_path(customer: customer.to_param)

    fill_in 'Stundensatz', with: 150
    fill_in 'Anzahl Stunden', with: 2.5
    fill_in 'Rechnungstext', with: text
    click_button 'Leistung erfassen'

    expect(page).to have_text('Leistung wurde erfasst')
  end

  scenario 'Suggestions', js: true do
    create :activity, customer: customer, employee: employee, text: 'Gugus'
    visit new_activity_path(customer: customer.to_param)

    page.execute_script("$('#activity_text_input').focus()")

    expect(page).to have_text('Gugus')
  end

  scenario 'Update a Activity' do
    visit edit_activity_path(activity)

    fill_in 'Rechnungstext', with: 'Aktualisierte Leistung'
    click_button 'Leistung aktualisieren'

    expect(page).to have_text('Leistung wurde gespeichert')
  end

  scenario 'Destroy a Activity' do
    visit edit_activity_path(activity)

    click_link 'Löschen'

    expect(page).to have_text 'Leistung wurde gelöscht.'
  end
end
