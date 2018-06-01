require 'rails_helper'

feature 'Login / Logout' do
  let!(:employee) do
    create :employee, name: 'Max',
                      email: 'someone@kms.ch',
                      password: 'password',
                      password_confirmation: 'password'
  end

  scenario 'login' do
    visit new_employee_session_path

    fill_in 'E-Mail-Adresse', with: 'someone@kms.ch'
    fill_in 'Passwort', with: 'password'

    click_button 'Anmelden'

    expect(current_path).to eq activities_path
  end

  scenario 'invalid login' do
    visit new_employee_session_path

    fill_in 'E-Mail-Adresse', with: 'someone@kms.ch'
    fill_in 'Passwort', with: 'wrong pw'

    click_button 'Anmelden'

    expect(page).to have_text 'Ungültige Anmeldedaten'
    expect(current_path).to eq new_employee_session_path
  end

  scenario 'logout' do
    sign_in employee

    visit root_path

    expect(current_path).to eq activities_path

    click_link 'Max abmelden'

    expect(current_path).to eq new_employee_session_path
  end
end
