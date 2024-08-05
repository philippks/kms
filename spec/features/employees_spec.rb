require 'rails_helper'

describe 'Managing Employees' do
  let(:employee) { create :employee, name: 'Hans Meier' }

  before do
    sign_in create :employee
  end

  it 'List Employees' do
    employee.touch

    visit employees_path
    expect(page).to have_text('Hans Meier')
  end

  it 'Create new Employee' do
    visit new_employee_path

    fill_in 'Name', with: 'Friedrich Schiller'
    fill_in 'E-Mail-Adresse', with: 'friedrich@schiller.ch'
    fill_in 'Initialen', with: 'FS'
    fill_in 'Stundensatz', with: 150
    select 'Sollstunden', from: 'Arbeitszeitmodel'
    fill_in 'Passwort', with: 'my secure password'
    fill_in 'Passwort bestätigen', with: 'my secure password'
    click_button 'Mitarbeiter erfassen'

    expect(page).to have_text('Mitarbeiter wurde erfasst')
  end

  it 'Update a Employee' do
    visit edit_employee_path(employee)

    fill_in 'Name', with: 'Friedrich Schiller'
    select 'Soll = Ist', from: 'Arbeitszeitmodel'
    click_button 'Mitarbeiter aktualisieren'

    expect(page).to have_text('Mitarbeiter wurde gespeichert')
  end

  it 'Destroy a Employee' do
    visit edit_employee_path(employee)

    click_link 'Löschen'

    expect(page).to have_text 'Mitarbeiter wurde gelöscht.'
  end
end
