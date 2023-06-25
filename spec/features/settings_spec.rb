require 'rails_helper'

feature 'Edit Settings' do
  let(:employee) { create :employee }

  before do
    sign_in employee
  end

  scenario 'Update settings' do
    visit settings_path

    expect(page).to have_field('Mehrwertsteuersätze für Rechnungen', with: '7.7,8.0,0.0')

    fill_in 'Mehrwertsteuersätze für Rechnungen', with: '8.1,7.7,0.0'
    click_button 'Sonstige Einstellungen aktualisieren'

    expect(page).to have_text('Sonstige Einstellungen wurde gespeichert')
    expect(page).to have_field('Mehrwertsteuersätze für Rechnungen', with: '8.1,7.7,0.0')
  end
end
