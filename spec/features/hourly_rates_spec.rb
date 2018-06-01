require 'rails_helper'

feature 'Managing Hourly Rates' do
  let(:employee) { create :employee }
  let!(:customer) { create :customer, name: 'Hans' }
  let(:hourly_rate) do
    create :hourly_rate, customer: customer, employee: employee, hourly_rate: 150
  end

  before do
    sign_in employee
  end

  scenario 'List Hourly Rates' do
    hourly_rate.touch

    visit employee_hourly_rates_path(employee)

    expect(page).to have_text('Hans')
    expect(page).to have_text('150.00')
  end

  scenario 'Create new Hourly Rate', js: true do
    visit new_employee_hourly_rate_path(employee)

    select2('Hans', from: 'Kunde', search: true)
    fill_in 'Stundensatz', with: 170

    click_button 'Stundensatz erfassen'

    expect(page).to have_text('Stundensatz wurde erfasst')
  end

  scenario 'Update a Hourly Rate' do
    visit edit_employee_hourly_rate_path(employee, hourly_rate)

    fill_in 'Stundensatz', with: 200
    click_button 'Stundensatz aktualisieren'

    expect(page).to have_text('Stundensatz wurde gespeichert')
  end

  scenario 'Destroy a Hourly Rate' do
    visit edit_employee_hourly_rate_path(employee, hourly_rate)

    click_link 'Löschen'

    expect(page).to have_text 'Stundensatz wurde gelöscht.'
  end
end
