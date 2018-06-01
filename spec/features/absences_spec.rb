require 'rails_helper'

feature 'Managing Absences' do
  let(:text) { 'Musste weg' }
  let(:employee) { create :employee }
  let(:absence) do
    attributes = (FactoryBot.build :absence, employee: employee).attributes.symbolize_keys
    create :absence, attributes.merge(text: text)
  end

  before do
    sign_in employee
  end

  scenario 'List Absences' do
    absence.touch

    visit absences_path
    expect(page).to have_text(text)
  end

  scenario 'Create new Absence' do
    visit new_absence_path

    fill_in 'Anzahl Stunden', with: 2.5
    fill_in 'Text', with: text
    fill_in 'Von', with: '2015-01-01'
    fill_in 'Bis', with: '2015-01-01'
    select 'Arzt', from: 'Abwesenheitsgrund'
    click_button 'Abwesenheit erfassen'

    expect(page).to have_text('Abwesenheit wurde erfasst')
  end

  scenario 'Update a Absence' do
    visit edit_absence_path(absence)

    fill_in 'Text', with: 'Aktualisierte Abwesenheit'
    click_button 'Abwesenheit aktualisieren'

    expect(page).to have_text('Abwesenheit wurde gespeichert')
  end

  scenario 'Destroy a Absence' do
    visit edit_absence_path(absence)

    click_link 'Löschen'

    expect(page).to have_text 'Abwesenheit wurde gelöscht.'
  end
end
